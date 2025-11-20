<?php

require_once '../../special_controllers/Controller.php';

class S_ExamTeachersController extends S_Controller
{
   
    public static function getAllExams()
    {
        // Query all Exams with their related info
        $data = self::execQuery("SELECT
                            t.teacher_id,
                            t.work_hours,
                            t.teacher_contact_id,
                            t.teacher_account_id,
                            t.first_name,
                            t.last_name,
                            t.profile_image,
                            CONCAT(
                                '[', 
                                IFNULL(GROUP_CONCAT(
                                    DISTINCT JSON_OBJECT(
                                        'exam_id', e.exam_id,
                                        'exam_level_id', e.exam_level_id,
                                        'exam_name_ar', e.exam_name_ar,
                                        'exam_name_en', e.exam_name_en,
                                        'exam_type', e.exam_type,
                                        'exam_sucess_min_point', e.exam_sucess_min_point,
                                        'exam_max_point', e.exam_max_point,
                                        'exam_memo_point', e.exam_memo_point,
                                        'exam_tjwid_app_point', e.exam_tjwid_app_point,
                                        'exam_tjwid_tho_point', e.exam_tjwid_tho_point,
                                        'exam_performance_point', e.exam_performance_point
                                    )
                                ), ''),
                                ']'
                            ) AS exams_json
                        FROM teacher t
                        LEFT JOIN exam_teacher et ON t.teacher_id = et.teacher_id
                        LEFT JOIN exam e ON et.exam_id = e.exam_id
                        GROUP BY t.teacher_id;


                                ");

        $formatted = [];

        foreach ($data as $row) {
            // Decode the exams JSON array
            $exams = isset($row['exams_json']) ? json_decode($row['exams_json'], true) : [];

            // Structure the teacher information
            $teacher = [
                'teacher_id' => $row['teacher_id'],
                'work_hours' => $row['work_hours'],
                'teacher_contact_id' => $row['teacher_contact_id'],
                'teacher_account_id' => $row['teacher_account_id'],
                'first_name' => $row['first_name'],
                'last_name' => $row['last_name'],
                'profile_image' => $row['profile_image']
            ];

            $formatted[] = [
                'exam' => is_array($exams) ? $exams : [],
                'teacher' => $teacher
            ];
        }


    
        
        self::sendResponse(200, $formatted);
    }

    public static function saveNewExam()
    {
        //todo implement and test


        $data = self::getRequestBody();
        if (!$data) {
            self::sendResponse(400, ['error' => 'Invalid JSON body']);
            return;
        }

        $conn = self::$dbconnection;

        try {
            $conn->connect()->begin_transaction();


            // 1. Insert account_info
            $account = $data['account_info'];
            $account = AccountInfo::create($conn, $account);

            // 5. Insert contact_info
            $contact = $data['contact_info'];
            $contact = ContactInfo::create($conn, $contact);

            $Exam = $data['info'];
            $Exam['Exam_account_id'] = $account->account_id;
            $Exam['Exam_contact_id'] = $contact->contact_id;
            $Exam = Exam::create($conn, $Exam);


            $data['account_info'] = $account;
            $data['info'] = $Exam;
            $data['contact_info'] = $contact;


            // Commit all
            $conn->commit();
            self::sendResponse(201, $data);

        } catch (Exception $e) {
            $conn->rollback();
            self::sendResponse(500, ['error' => 'Transaction failed: ' . $e->getMessage()]);
        }
    }

    public static function updateExam()
    {
        //todo implement and test

        
        $data = self::getRequestBody();
        if (!$data || !isset($data['info']['Exam_id'])) {
            self::sendResponse(400, ['error' => 'Invalid JSON body or missing Exam_id']);
            return;
        }

        $conn = self::$dbconnection;

        try {
            $conn->connect()->begin_transaction();

            // Validate Exam_id, contact_id, and account_id
            if (
                empty($data['info']['Exam_id']) ||
                empty($data['contact_info']['contact_id']) ||
                empty($data['account_info']['account_id'])
            ) {
                throw new Exception('Missing required IDs for update');
            }

            // 1. Update account_info
            $account = new AccountInfo($data['account_info']);
            $account->update($conn);

            // 2. Update contact_info
            $contact = new ContactInfo($data['contact_info']);
            $contact->update($conn);

            // 3. Update Exam info
            $Exam = new Exam($data['info']);
            $Exam->update($conn);

            $data['account_info'] = $account;
            $data['info'] = $Exam;
            $data['contact_info'] = $contact;

            // Commit all
            $conn->commit();
            self::sendResponse(200, $data);

        } catch (Exception $e) {
            $conn->rollback();
            self::sendResponse(500, ['error' => 'Transaction failed: ' . $e->getMessage()]);
        }
    }
}
