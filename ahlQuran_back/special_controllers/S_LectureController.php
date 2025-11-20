<?php

require_once '../../special_controllers/Controller.php';

class S_LectureController extends S_Controller
{
   
    public static function getAllLectures()
    {
        $data = self::execQuery("SELECT
                        JSON_OBJECT(
                        'lecture_id', l.lecture_id,
                        'lecture_name_ar', l.lecture_name_ar,
                        'lecture_name_en', l.lecture_name_en,
                        'circle_type', l.circle_type,
                        'show_on_website', l.shown_on_website
                        ) AS lecture,
                        COUNT(DISTINCT ls.student_id) AS student_count,
                        CONCAT(
                        '[', 
                        IFNULL(
                            GROUP_CONCAT(
                            DISTINCT JSON_OBJECT(
                                'teacher_id', t.teacher_id,
                                'first_name', t.first_name,
                                'last_name', t.last_name
                            ) SEPARATOR ','
                            ), 
                            ''
                        ), 
                        ']'
                        ) AS teachers,
                        CONCAT(
                        '[', 
                        IFNULL(
                            GROUP_CONCAT(
                            DISTINCT JSON_OBJECT(
                                'day_of_week', ws.day_of_week,
                                'start_time', ws.start_time,
                                'end_time', ws.end_time
                            ) SEPARATOR ','
                            ), 
                            ''
                        ), 
                        ']'
                        ) AS schedules
                        FROM lecture l
                        LEFT JOIN lecture_student ls ON l.lecture_id = ls.lecture_id
                        LEFT JOIN lecture_teacher lt ON l.lecture_id = lt.lecture_id
                        LEFT JOIN teacher t ON lt.teacher_id = t.teacher_id
                        LEFT JOIN weekly_schedule ws ON l.lecture_id = ws.lecture_id
                        GROUP BY l.lecture_id, l.lecture_name_ar, l.lecture_name_en, l.circle_type, l.shown_on_website
                    ");

        // Remove extra slashes from JSON fields and decode them
        foreach ($data as &$row) {
            if (isset($row['lecture'])) {
            $row['lecture'] = json_decode($row['lecture'], true);
            }
            if (isset($row['teachers'])) {
            $row['teachers'] = json_decode($row['teachers'], true);
            }
            if (isset($row['schedules'])) {
            $row['schedules'] = json_decode($row['schedules'], true);
            }
        }
        unset($row);

        
        self::sendResponse(200, $data);
    }

    public static function saveNewLecture()
    {
        $data = self::getRequestBody();
        if (!$data) {
            self::sendResponse(400, ['error' => 'Invalid JSON body']);
            return;
        }

        $conn = self::$dbconnection;

        try {
            $conn->connect()->begin_transaction();

            // 1. Insert lecture
            $lectureData = $data['lecture'];
            $lecture = Lecture::create($conn, $lectureData);
            $data['lecture'] = $lecture;

            // 2. Insert teachers
            if (isset($data['teachers']) && is_array($data['teachers'])) {
                foreach ($data['teachers'] as $teacherData) {
                    LectureTeacher::create($conn, [
                        'lecture_id' => $lecture->lecture_id,
                        'teacher_id' => $teacherData['teacher_id']
                    ]);
                }
            }

            // 3. Insert schedules
            if (isset($data['schedules']) && is_array($data['schedules'])) {
                foreach ($data['schedules'] as $scheduleData) {
                    $scheduleData['lecture_id'] = $lecture->lecture_id;
                    WeeklySchedule::create($conn, $scheduleData);
                }
            }


            // Commit all
            $conn->commit();
            self::sendResponse(201, $data);

        } catch (Exception $e) {
            $conn->rollback();
            self::sendResponse(500, ['error' => 'Transaction failed: ' . $e->getMessage()]);
        }
    }

    public static function updateLecture()
    {
        $data = self::getRequestBody();
        if (!$data || !isset($data['lecture']['lecture_id'])) {
            self::sendResponse(400, ['error' => 'Invalid JSON body or missing lecture_id']);
            return;
        }

        $conn = self::$dbconnection;

        try {
            $conn->connect()->begin_transaction();

            // 1. Update lecture
            $lectureData = $data['lecture'];
            $lecture = new Lecture($lectureData);
            $lecture->update($conn, $lectureData['lecture_id']);

            // 2. Update teachers: remove old, insert new
            $lectureTeachers = new LectureTeacher($data['teachers'][0]);
            $lectureTeachers->deleteById($conn, NULL , $lectureData['lecture_id']);
            if (isset($data['teachers']) && is_array($data['teachers'])) {
                foreach ($data['teachers'] as $teacherData) {
                    LectureTeacher::create($conn, [
                        'lecture_id' => $lectureData['lecture_id'],
                        'teacher_id' => $teacherData['teacher_id']
                    ]);
                }
            }

            // 3. Update schedules: remove old, insert new
            if (!empty($data['schedules']) ) {
               $weeklySchedule = new WeeklySchedule($data['schedules'][0]);
                $weeklySchedule->delete($conn);
            }
            if (isset($data['schedules']) && is_array($data['schedules'])) {
                foreach ($data['schedules'] as $scheduleData) {
                    $weeklySchedule = new WeeklySchedule($scheduleData);
                    $weeklySchedule->update($conn);
                }
            }

            $conn->commit();
            self::sendResponse(200, ['message' => 'Lecture updated successfully']);

        } catch (Exception $e) {
            $conn->rollback();
            self::sendResponse(500, ['error' => 'Transaction failed: ' . $e->getMessage()]);
        }
    }

}
