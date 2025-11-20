<?php

require_once '../../models/AccountInfo.php';
require_once '../../controllers/Controller.php';

class AccountInfoController extends Controller
{
    
    public static function auth(){
        $data = self::getRequestBody();
        if (!$data) {
            self::sendResponse(500, ['error' => 'body is empty']);
            return;
        }
        try{
            if (!isset($data["account_type"])) {
                self::sendResponse(500, ['error' => 'account_type is not set !!']);
                return;
            }

            $account_id = AccountInfo::checkCredentials(self::$dbconnection, $data);
            if ($account_id == -1) {
                self::sendResponse(500, ['error' => 'the credentials are wrong (pw or username or account_type is wrong) !!']);
                return;
            }

            $obj = null;
            switch ($data["account_type"]) {
                case "guardian": $obj = Guardian::getByAccountId(self::$dbconnection, $account_id); break;
                case "student": $obj = Student::getByAccountId(self::$dbconnection, $account_id); break;
                case "teacher": $obj = Teacher::getByAccountId(self::$dbconnection, $account_id);break;
                case "superviser": $obj = Supervisor::getByAccountId(self::$dbconnection, $account_id);break;
            }

            if ($obj == null) {
                self::sendResponse(500, ['error' => 'no profile is found for account_id : '.$account_id.' of type : '.$data["account_type"]]);
                return;
            }

            self::sendResponse(201, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function newAccount(){
        $data = self::getRequestBody();
        if (!$data) {
            self::sendResponse(500, ['error' => 'body is empty']);
            return;
        }
        try{
            if (!isset($data["account_type"])) {
                self::sendResponse(500, ['error' => 'account_type is not set !!']);
                return;
            }

            $obj = AccountInfo::create(self::$dbconnection, $data);
            $account_id = $obj->account_id;


            $obj = null;
            switch ($data["account_type"]) {
                case "guardian": $obj = Guardian::createAssociatedProfile(self::$dbconnection, $account_id); break;
                case "student": $obj = Student::createAssociatedProfile(self::$dbconnection, $account_id);   PersonalInfo::createNewProfile(self::$dbconnection, $obj->student_id);break;
                case "teacher": $obj = Teacher::createAssociatedProfile(self::$dbconnection, $account_id);break;
                case "superviser": $obj = Supervisor::createAssociatedProfile(self::$dbconnection, $account_id);break;
            }

            if ($obj == null) {
                self::sendResponse(500, ['error' => 'no profile is found for account_id : '.$account_id.' of type : '.$data["account_type"]]);
                return;
            }

            self::sendResponse(201, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }
    
    public static function getAll() {
        try {
            $obj = AccountInfo::getAll(self::$dbconnection);
            self::sendResponse(200, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function getOne(int ...$id) {
        try {
            $obj = AccountInfo::get(self::$dbconnection, (int)$id[0]);
          self::sendResponse(200, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function save() {
        $data = self::getRequestBody();
        if (!$data) {
            self::sendResponse(500, ['error' => 'body is empty']);
            return;
        }
        try {
            $obj = AccountInfo::create(self::$dbconnection, $data);
            self::sendResponse(201, $obj);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function update(int ...$id) {
        $data = self::getRequestBody();
        if (!$data) return;

        try {
            $existing = AccountInfo::get(self::$dbconnection, (int)$id[0]);
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
            $existing = AccountInfo::get(self::$dbconnection, (int)$id[0]);
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
