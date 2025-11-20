<?php

require_once '../../models/ExamTeacher.php';
require_once '../../controllers/Controller.php';

class ExamTeacherController extends Controller
{
    
    public static function getAll() {
        try {
            $obj = ExamTeacher::getAll(self::$dbconnection);
            self::sendResponse(200, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function getOne(int ...$id) {
        try {
            $obj = ExamTeacher::get(self::$dbconnection, (int)$id[0],(int)$id[1] );
          self::sendResponse(200, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function save() {
        $data = self::getRequestBody();
        if (!$data) return;
        try {
            $obj = ExamTeacher::create(self::$dbconnection, $data);
            self::sendResponse(201, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function update(int ...$id) {
        $data = self::getRequestBody();
        if (!$data) return;

        try {
            $existing = ExamTeacher::get(self::$dbconnection, (int)$id[0],(int)$id[1]);
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
            $existing = ExamTeacher::get(self::$dbconnection, (int)$id[0],(int)$id[1]);
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
}
