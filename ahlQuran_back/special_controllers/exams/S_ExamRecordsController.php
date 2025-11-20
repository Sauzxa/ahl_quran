<?php

require_once '../../special_controllers/Controller.php';

class S_ExamRecordsController extends S_Controller
{
   
    public static function getAllExams()
    {
        // Query all Exams with their related info
        $result = self::execQuery("SELECT
                                JSON_OBJECT(
                                    'exam', JSON_OBJECT(
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
                                    ),
                                    'student', JSON_OBJECT(
                                    'student_id', s.student_id,
                                    'guardian_id', s.guardian_id,
                                    'student_contact_id', s.student_contact_id,
                                    'student_account_id', s.student_account_id
                                    ),
                                    'personal_info', JSON_OBJECT(
                                    'student_id', pi.student_id,
                                    'first_name_ar', pi.first_name_ar,
                                    'last_name_ar', pi.last_name_ar,
                                    'first_name_en', pi.first_name_en,
                                    'last_name_en', pi.last_name_en,
                                    'nationality', pi.nationality,
                                    'sex', pi.sex,
                                    'date_of_birth', pi.date_of_birth,
                                    'place_of_birth', pi.place_of_birth,
                                    'home_address', pi.home_address,
                                    'father_status', pi.father_status,
                                    'mother_status', pi.mother_status,
                                    'profile_image', pi.profile_image
                                    ),
                                    'exam_student', JSON_OBJECT(
                                    'exam_id', es.exam_id,
                                    'student_id', es.student_id,
                                    'appreciation_id', es.appreciation_id,
                                    'point_hifd', es.point_hifd,
                                    'point_tajwid_applicative', es.point_tajwid_applicative,
                                    'point_tajwid_theoric', es.point_tajwid_theoric,
                                    'point_performance', es.point_performance,
                                    'point_deduction_tal', es.point_deduction_tal9ini,
                                    'point_deduction_tanbihi', es.point_deduction_tanbihi,
                                    'point_deduction_tajwidi', es.point_deduction_tajwidi,
                                    'date_take_exam', es.date_take_exam
                                    )
                                ) AS exam_student_data
                                FROM exam_student es
                                JOIN exam e ON es.exam_id = e.exam_id
                                JOIN student s ON es.student_id = s.student_id
                                JOIN personal_info pi ON s.student_id = pi.student_id
                                ");

        // Remove extra slashes and decode JSON for each row
        $data = [];
        foreach ($result as $row) {
            $json = $row['exam_student_data'];
            $data[] = json_decode($json, true);
        }

        
        self::sendResponse(200, $data);
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
