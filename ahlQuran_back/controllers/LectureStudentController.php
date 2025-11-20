<?php

require_once '../../models/LectureStudent.php';
require_once '../../controllers/Controller.php';

class LectureStudentController extends Controller
{
    
    public static function getAll() {
        try {
            $obj = LectureStudent::getAll(self::$dbconnection);
            self::sendResponse(200, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function getOne(int ...$id) {
        try {
            $obj = LectureStudent::get(self::$dbconnection, (int)$id[0], (int)$id[1]);
          self::sendResponse(200, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function save() {
        $data = self::getRequestBody();
        if (!$data) return;
        try {
            $obj = LectureStudent::create(self::$dbconnection, $data);
            self::sendResponse(201, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function update(int ...$id) {
        $data = self::getRequestBody();
        if (!$data) return;

        try {
            $existing = LectureStudent::get(self::$dbconnection, (int)$id[0], (int)$id[1]);
            if (!$existing) {
                self::sendResponse(404, ['error' => 'Not found']);
                return;
            }
            foreach ($data as $k => $v) {
                if (property_exists($existing, $k)) {
                    $existing->$k = $v;
                }
            }
            if ($existing->update(self::$dbconnection)) {
                self::sendResponse(200, $existing);
            } else {
                self::sendResponse(500, ['error' => 'Update failed']);
            }
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function delete(int ...$id) {
        try {
            $existing = LectureStudent::get(self::$dbconnection, (int)$id[0], (int)$id[1]);
            if (!$existing) {
                self::sendResponse(404, ['error' => 'Not found']);
                return;
            }
            if ($existing->delete(self::$dbconnection)) {
                self::sendResponse(200, ['message' => 'Deleted']);
            } else {
                self::sendResponse(500, ['error' => 'Delete failed']);
            }
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function getStudentLectures(int ...$id) {
        try {
            $obj = LectureStudent::getStudentLectures(self::$dbconnection, (int)$id[0]);
          self::sendResponse(200, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function getLecturesStudents(int ...$id){
        try {
            $obj = LectureStudent::getLecturesStudents(self::$dbconnection, (int)$id[0]);
          self::sendResponse(200, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }
}
