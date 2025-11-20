<?php

require_once '../../special_controllers/Controller.php';

class S_StudentController extends S_Controller
{
   
    public static function getAllStudents()
    {
        $data = self::execQuery(" SELECT
    JSON_OBJECT(
      'personalInfo', JSON_OBJECT(
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
      'accountInfo', JSON_OBJECT(
        'account_id', ai.account_id,
        'username', ai.username,
        'passcode', ai.passcode,
        'account_type', ai.account_type
      ),
      'contactInfo', JSON_OBJECT(
        'contact_id', ci.contact_id,
        'email', ci.email,
        'phone_number', ci.phone_number
      ),
      'medicalInfo', JSON_OBJECT(
        'student_id', mi.student_id,
        'blood_type', mi.blood_type,
        'allergies', mi.allergies,
        'diseases', mi.diseases,
        'diseases_causes', mi.diseases_causes
      ),
      'guardian', JSON_OBJECT(
        'guardian_id', g.guardian_id,
        'first_name', g.first_name,
        'last_name', g.last_name,
        'date_of_birth', g.date_of_birth,
        'relationship', g.relationship,
        'guardian_contact_id', g.guardian_contact_id,
        'guardian_account_id', g.guardian_account_id,
        'home_address', g.home_address,
        'job', g.job,
        'profile_image', g.profile_image
      ),
      'student', JSON_OBJECT(
        'student_id', s.student_id,
        'guardian_id', s.guardian_id,
        'student_contact_id', s.student_contact_id,
        'student_account_id', s.student_account_id
      ),
      'lectures', CONCAT(
        '[', 
        IFNULL(
          GROUP_CONCAT(
            DISTINCT JSON_OBJECT(
              'lecture_id', l.lecture_id,
              'team_accomplishment_id', l.team_accomplishment_id,
              'lecture_name_ar', l.lecture_name_ar,
              'lecture_name_en', l.lecture_name_en,
              'shown_on_website', l.shown_on_website,
              'circle_type', l.circle_type
            )
          ), ''
        ),
        ']'
      ),
      'formalEducationInfo', JSON_OBJECT(
        'student_id', fei.student_id,
        'school_name', fei.school_name,
        'school_type', fei.school_type,
        'grade', fei.grade,
        'academic_level', fei.academic_level
      ),
      'subscriptionInfo', JSON_OBJECT(
        'subscription_id', si.subscription_id,
        'student_id', si.student_id,
        'enrollment_date', si.enrollment_date,
        'exit_date', si.exit_date,
        'exit_reason', si.exit_reason,
        'is_exempt_from_payment', si.is_exempt_from_payment,
        'exemption_percentage', si.exemption_percentage
      )
    ) AS student_data
  FROM student s
  LEFT JOIN personal_info pi ON s.student_id = pi.student_id
  LEFT JOIN account_info ai ON s.student_account_id = ai.account_id
  LEFT JOIN contact_info ci ON s.student_contact_id = ci.contact_id
  LEFT JOIN medical_info mi ON s.student_id = mi.student_id
  LEFT JOIN guardian g ON s.guardian_id = g.guardian_id
  LEFT JOIN formal_education_info fei ON s.student_id = fei.student_id
  LEFT JOIN subscription_info si ON s.student_id = si.student_id
  LEFT JOIN lecture_student ls ON s.student_id = ls.student_id
  LEFT JOIN lecture l ON ls.lecture_id = l.lecture_id
  GROUP BY s.student_id
");

foreach ($data as &$row) {
    if (!isset($row['student_data'])) {
        continue;
    }

    // 1. Decode the top-level JSON string
    $decoded = json_decode($row['student_data'], true);

    if (is_array($decoded)) {
        // 2. For each key in the decoded array, if it's a string,
        //    try to json_decode() it as well.
        foreach ($decoded as $key => $value) {
            if (is_string($value)) {
                $nested = json_decode($value, true);
                if (is_array($nested)) {
                    $decoded[$key] = $nested;
                }
            }
        }

        // 3. Replace the original row with the fully decoded structure
        $row = $decoded;
    }

    // 4. Remove the raw JSON column, since we no longer need it
    unset($row['student_data']);
}
unset($row);




        self::sendResponse(200, $data);
    }

    public static function saveNewStudent()
    {
        $data = self::getRequestBody();


        if (!$data) {
            self::sendResponse(400, ['error' => 'Invalid JSON body']);
            return;
        }

        $conn = self::$dbconnection;

        try {
            $conn->connect()->begin_transaction();

            // 6. Insert guardian
            $guardian = $data['guardian'];


            // 1. Insert account_info
            $account = $data['accountInfo'];
            $account = AccountInfo::create($conn, $account);

            // 5. Insert contact_info
            $contact = $data['contactInfo'];
            $contact = ContactInfo::create($conn, $contact);


            // 2. Insert student (with student_account_id)
            $student = $data['student'];
            $student['guardian_id'] = $guardian['guardian_id'] ?? null; // Optional guardian_id
            $student['student_contact_id'] = $account->account_id; // Set the account_id from AccountInfo
            $student['student_account_id'] = $contact->contact_id; // Set the contact_id from ContactInfo
            $student = Student::create($conn, $student);

            // 3. Insert personal_info
            $personal = $data['personalInfo'];
            $personal['student_id'] = $student->student_id; // Set the student_id from Student
            PersonalInfo::create($conn, $personal);

            // 4. Insert medical_info
            $medical = $data['medicalInfo'];
            $medical['student_id'] = $student->student_id; // Set the student_id from Student
            MedicalInfo::create($conn, $medical);

            

            
            

            // 7. Insert formal_education_info
            $formalEdu = $data['formalEducationInfo'];
            $formalEdu['student_id'] = $student->student_id; // Set the student_id from Student
            FormalEducationInfo::create($conn, $formalEdu);

            // 8. Insert subscription_info
            $sub = $data['subscriptionInfo'];
            $sub['student_id'] = $student->student_id; // Set the student_id from Student
            $sub['is_exempt_from_payment'] = (int)$sub['is_exempt_from_payment'];
            SubscriptionInfo::create($conn, $sub);

            // 9. Insert lecture_student mapping
            foreach ($data['lectures'] as $lecture) {
               LectureStudent::create($conn, [
                    'student_id' => $student->student_id,
                    'lecture_id' => $lecture['lecture_id']
                ]);
            }

            $data['accountInfo'] = $account;
            $data['contactInfo'] = $contact;
            $data['student'] = $student;
            $data['personalInfo'] = $personal;
            $data['medicalInfo'] = $medical;
            $data['formalEducationInfo'] = $formalEdu;
            $data['subscriptionInfo'] = $sub;


            // Commit all
            $conn->commit();
            self::sendResponse(201, $data);

        } catch (Exception $e) {
            $conn->rollback();
            self::sendResponse(500, ['error' => 'Transaction failed: ' . $e->getMessage()]);
        }
    }

    public static function updateStudent()
    {
        $data = self::getRequestBody();
        if (!$data || !isset($data['student']['student_id'])) {
            self::sendResponse(400, ['error' => 'Invalid JSON body or missing student_id '. json_decode($data)]);
            return;
        }

        $conn = self::$dbconnection;

        try {
            $conn->connect()->begin_transaction();

            // 1. Update account_info
            $account = new AccountInfo($data['accountInfo']);
            $account->update($conn);

            // 2. Update contact_info
            $contact = new ContactInfo($data['contactInfo']);
            $contact->update($conn);

            // 3. Update student
            $student = new Student($data['student']);
            $student->update($conn);

            // 4. Update personal_info
            $personal = new PersonalInfo($data['personalInfo']);
            $personal->update($conn);

            // 5. Update medical_info
            $medical = new MedicalInfo($data['medicalInfo']);
            $medical->update($conn);

            // 6. Update formal_education_info
            $formalEdu = new FormalEducationInfo($data['formalEducationInfo']);
            $formalEdu->update($conn);

            // 7. Update subscription_info
            $sub = new SubscriptionInfo($data['subscriptionInfo']);
            $sub->update($conn);

            // 8. Update lecture_student mapping
            LectureStudent::deleteById($conn, NULL, $student->student_id);
            foreach ($data['lectures'] as $lecture) {
                LectureStudent::create($conn, [
                    'student_id' =>  $student->student_id,
                    'lecture_id' => $lecture['lecture_id']
                ]);
            }

            $conn->commit();
            self::sendResponse(200, $data);

        } catch (Exception $e) {
            $conn->rollback();
            self::sendResponse(500, ['error' => 'Transaction failed: ' . $e->getMessage()]);
        }
    }

}
