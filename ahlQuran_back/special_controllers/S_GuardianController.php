<?php

require_once '../../special_controllers/Controller.php';

class S_GuardianController extends S_Controller
{
   
    public static function getAllGuardians()
    {
        // Query all guardians with their related info
        $rows = self::execQuery("SELECT
            g.guardian_id,
            g.first_name,
            g.last_name,
            g.date_of_birth,
            g.relationship,
            g.guardian_contact_id,
            g.guardian_account_id,
            g.home_address,
            g.job,
            g.profile_image,
            ci.contact_id,
            ci.email,
            ci.phone_number,
            ai.account_id,
            ai.username,
            ai.passcode,
            ai.account_type,
            s.student_id,
            pi.first_name_ar,
            pi.last_name_ar,
            pi.first_name_en,
            pi.last_name_en,
            pi.nationality,
            pi.sex,
            pi.date_of_birth AS student_date_of_birth,
            pi.place_of_birth,
            pi.home_address AS student_home_address,
            pi.father_status,
            pi.mother_status,
            pi.profile_image AS student_profile_image
            FROM guardian g
            LEFT JOIN contact_info ci ON g.guardian_contact_id = ci.contact_id
            LEFT JOIN account_info ai ON g.guardian_account_id = ai.account_id
            LEFT JOIN student s ON g.guardian_id = s.guardian_id
            LEFT JOIN personal_info pi ON s.student_id = pi.student_id
            ORDER BY g.guardian_id
        ");

        // Group data by guardian
        $guardians = [];
        foreach ($rows as $row) {
            $gid = $row['guardian_id'];
            if (!isset($guardians[$gid])) {
            $guardians[$gid] = [
                'info' => [
                'guardian_id' => $row['guardian_id'],
                'first_name' => $row['first_name'],
                'last_name' => $row['last_name'],
                'date_of_birth' => $row['date_of_birth'],
                'relationship' => $row['relationship'],
                'guardian_contact_id' => $row['guardian_contact_id'],
                'guardian_account_id' => $row['guardian_account_id'],
                'home_address' => $row['home_address'],
                'job' => $row['job'],
                'profile_image' => $row['profile_image'],
                ],
                'contact_info' => [
                'contact_id' => $row['contact_id'],
                'email' => $row['email'],
                'phone_number' => $row['phone_number'],
                ],
                'account_info' => [
                'account_id' => $row['account_id'],
                'username' => $row['username'],
                'passcode' => $row['passcode'],
                'account_type' => $row['account_type'],
                ],
                'children' => [],
            ];
            }
            // Add child if exists
            if (!empty($row['student_id'])) {
            $guardians[$gid]['children'][] = [
                'student_id' => $row['student_id'],
                'first_name_ar' => $row['first_name_ar'],
                'last_name_ar' => $row['last_name_ar'],
                'first_name_en' => $row['first_name_en'],
                'last_name_en' => $row['last_name_en'],
                'nationality' => $row['nationality'],
                'sex' => $row['sex'],
                'date_of_birth' => $row['student_date_of_birth'],
                'place_of_birth' => $row['place_of_birth'],
                'home_address' => $row['student_home_address'],
                'father_status' => $row['father_status'],
                'mother_status' => $row['mother_status'],
                'profile_image' => $row['student_profile_image'],
            ];
            }
        }

        // Re-index as array
        $data = array_values($guardians);

        
        self::sendResponse(200, $data);
    }

    public static function saveNewGuardian()
    {
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

            $guardian = $data['info'];
            $guardian['guardian_account_id'] = $account->account_id;
            $guardian['guardian_contact_id'] = $contact->contact_id;
            $guardian = Guardian::create($conn, $guardian);


            $data['account_info'] = $account;
            $data['info'] = $guardian;
            $data['contact_info'] = $contact;


            // Commit all
            $conn->commit();
            self::sendResponse(201, $data);

        } catch (Exception $e) {
            $conn->rollback();
            self::sendResponse(500, ['error' => 'Transaction failed: ' . $e->getMessage()]);
        }
    }

    public static function updateGuardian()
    {
        $data = self::getRequestBody();
        if (!$data || !isset($data['info']['guardian_id'])) {
            self::sendResponse(400, ['error' => 'Invalid JSON body or missing guardian_id']);
            return;
        }

        $conn = self::$dbconnection;

        try {
            $conn->connect()->begin_transaction();

            // Validate guardian_id, contact_id, and account_id
            if (
                empty($data['info']['guardian_id']) ||
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

            // 3. Update guardian info
            $guardian = new Guardian($data['info']);
            $guardian->update($conn);

            $data['account_info'] = $account;
            $data['info'] = $guardian;
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
