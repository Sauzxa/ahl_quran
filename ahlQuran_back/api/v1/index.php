<?php
// Show errors for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// --- Set CORS and content headers ---
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept");
header("Access-Control-Max-Age: 86400"); // Cache preflight for 24 hours
header("Content-Type: application/json; charset=UTF-8");

// Handle OPTIONS requests immediately (for CORS preflight)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// --- Core Includes ---
require_once './router.php';
require_once '../../db.php';
require_once '../../controllers/Controller.php';
require_once '../../vendor/autoload.php';
// --- Controllers ---
{
    require_once '../../controllers/AccountInfoController.php';
    require_once '../../controllers/AppreciationController.php';
    require_once '../../controllers/ContactInfoController.php';
    require_once '../../controllers/Controller.php';
    require_once '../../controllers/ExamController.php';
    require_once '../../controllers/ExamLevelController.php';
    require_once '../../controllers/ExamStudentController.php';
    require_once '../../controllers/ExamTeacherController.php';
    require_once '../../controllers/FormalEducationInfoController.php';
    require_once '../../controllers/GoldenRecordController.php';
    require_once '../../controllers/GuardianController.php';
    require_once '../../controllers/LectureContentController.php';
    require_once '../../controllers/LectureController.php';
    require_once '../../controllers/LectureStudentController.php';
    require_once '../../controllers/LectureTeacherController.php';
    require_once '../../controllers/MedicalInfoController.php';
    require_once '../../controllers/PersonalInfoController.php';
    require_once '../../controllers/RequestCopyController.php';
    require_once '../../controllers/StudentController.php';
    require_once '../../controllers/StudentLectureAchievementsController.php';
    require_once '../../controllers/SubscriptionInfoController.php';
    require_once '../../controllers/SupervisorController.php';
    require_once '../../controllers/TeacherController.php';
    require_once '../../controllers/TeamAccomplishmentController.php';
    require_once '../../controllers/TeamAccomplishmentStudentController.php';
    require_once '../../controllers/WeeklyScheduleController.php';
    require_once '../../controllers/SupervisorAttendanceController.php';
}

// --- Special Controllers ---
{
    require_once '../../special_controllers/Controller.php';
    require_once '../../special_controllers/S_StudentController.php';
    require_once '../../special_controllers/S_GuardianController.php';
    require_once '../../special_controllers/exams/S_ExamRecordsController.php';
    require_once '../../special_controllers/exams/S_ExamTeachersController.php';
    require_once '../../special_controllers/S_LectureController.php';
}

use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable('../../');
$dotenv->load();

$db = new DB("localhost", "root", "", "quran");
Controller::setDbConnection($db);
S_Controller::setDbConnection($db);
$router = Router::getInstance($_ENV['BASE_URL']);
$router->setPrefix('/api/v1');


$router->get('/', fn() => var_dump(json_encode(['response' => 'API v1'])));

{
    // Routes for authentication
    $router->post('/auth/login',  ['AccountInfoController', 'auth']);
    $router->post('/auth/signup',  ['AccountInfoController', 'newAccount']);



    // Routes for AccountInfoController
    $router->get('/accountinfos',  ['AccountInfoController', 'getAll']);
    $router->get('/accountinfos/:id',  ['AccountInfoController', 'getOne']);
    $router->post('/accountinfos',  ['AccountInfoController', 'save']);
    $router->patch('/accountinfos/:id',  ['AccountInfoController', 'update']);
    $router->delete('/accountinfos/:id',  ['AccountInfoController', 'delete']);


    // Routes for AppreciationController
    $router->get('/appreciations',  ['AppreciationController', 'getAll']);
    $router->get('/appreciations/:id',  ['AppreciationController', 'getOne']);
    $router->post('/appreciations',  ['AppreciationController', 'save']);
    $router->patch('/appreciations/:id',  ['AppreciationController', 'update']);
    $router->delete('/appreciations/:id',  ['AppreciationController', 'delete']);


    // Routes for ContactInfoController
    $router->get('/contactinfos',  ['ContactInfoController', 'getAll']);
    $router->get('/contactinfos/:id',  ['ContactInfoController', 'getOne']);
    $router->post('/contactinfos',  ['ContactInfoController', 'save']);
    $router->patch('/contactinfos/:id',  ['ContactInfoController', 'update']);
    $router->delete('/contactinfos/:id',  ['ContactInfoController', 'delete']);


    // Routes for ExamController
    $router->get('/exams',  ['ExamController', 'getAll']);
    $router->get('/exams/:id',  ['ExamController', 'getOne']);
    $router->post('/exams',  ['ExamController', 'save']);
    $router->patch('/exams/:id',  ['ExamController', 'update']);
    $router->delete('/exams/:id',  ['ExamController', 'delete']);


    // Routes for ExamLevelController
    $router->get('/examlevels',  ['ExamLevelController', 'getAll']);
    $router->get('/examlevels/:id',  ['ExamLevelController', 'getOne']);
    $router->post('/examlevels',  ['ExamLevelController', 'save']);
    $router->patch('/examlevels/:id',  ['ExamLevelController', 'update']);
    $router->delete('/examlevels/:id',  ['ExamLevelController', 'delete']);


    // Routes for ExamStudentController
    $router->get('/examstudents',  ['ExamStudentController', 'getAll']);
    $router->get('/examstudents/exams/:id/students/:id',  ['ExamStudentController', 'getOne']);
    $router->post('/examstudents',  ['ExamStudentController', 'save']);
    $router->patch('/examstudents/exams/:idExam/students/:idStudent',  ['ExamStudentController', 'update']);
    $router->delete('/examstudents/exams/:idExam/students/:idStudent',  ['ExamStudentController', 'delete']);


    // Routes for ExamTeacherController
    $router->get('/examteachers',  ['ExamTeacherController', 'getAll']);
    $router->get('/examteachers/exams/:idExam/teachers/:id',  ['ExamTeacherController', 'getOne']);
    $router->post('/examteachers',  ['ExamTeacherController', 'save']);
    $router->patch('/examteachers/exams/:id/teachers/:id',  ['ExamTeacherController', 'update']);
    $router->delete('/examteachers/exams/:id/teachers/:id',  ['ExamTeacherController', 'delete']);


    // Routes for FormalEducationInfoController
    $router->get('/formaleducationinfos',  ['FormalEducationInfoController', 'getAll']);
    $router->get('/formaleducationinfos/:id',  ['FormalEducationInfoController', 'getOne']);
    $router->post('/formaleducationinfos',  ['FormalEducationInfoController', 'save']);
    $router->patch('/formaleducationinfos/:id',  ['FormalEducationInfoController', 'update']);
    $router->delete('/formaleducationinfos/:id',  ['FormalEducationInfoController', 'delete']);


    // Routes for GoldenRecordController
    $router->get('/goldenrecords',  ['GoldenRecordController', 'getAll']);
    $router->get('/goldenrecords/:id',  ['GoldenRecordController', 'getOne']);
    $router->post('/goldenrecords',  ['GoldenRecordController', 'save']);
    $router->patch('/goldenrecords/:id',  ['GoldenRecordController', 'update']);
    $router->delete('/goldenrecords/:id',  ['GoldenRecordController', 'delete']);


    // Routes for GuardianController
    $router->get('/guardians',  ['GuardianController', 'getAll']);
    $router->get('/guardians/:id',  ['GuardianController', 'getOne']);
    $router->post('/guardians',  ['GuardianController', 'save']);
    $router->patch('/guardians/:id',  ['GuardianController', 'update']);
    $router->delete('/guardians/:id',  ['GuardianController', 'delete']);


    // Routes for LectureContentController
    $router->get('/lecturecontents',  ['LectureContentController', 'getAll']);
    $router->get('/lecturecontents/:id',  ['LectureContentController', 'getOne']);
    $router->post('/lecturecontents',  ['LectureContentController', 'save']);
    $router->patch('/lecturecontents/:id',  ['LectureContentController', 'update']);
    $router->delete('/lecturecontents/:id',  ['LectureContentController', 'delete']);


    // Routes for LectureController
    $router->get('/lectures',  ['LectureController', 'getAll']);
    $router->get('/lectures/ar_name-and-id',  ['LectureContentController', 'getARNameAndIdOnly']);
    $router->get('/lectures/:id',  ['LectureController', 'getOne']);
    $router->post('/lectures',  ['LectureController', 'save']);
    $router->patch('/lectures/:id',  ['LectureController', 'update']);
    $router->delete('/lectures/:id',  ['LectureController', 'delete']);


    // Routes for LectureStudentController
    $router->get('/lecturestudents',  ['LectureStudentController', 'getAll']);
    $router->get('/lecturestudents/lectures/:id/students/:id',  ['LectureStudentController', 'getOne']);
    $router->get('/lecturestudents/lectures/students/:id',  ['LectureStudentController', 'getStudentLectures']);
    $router->get('/lecturestudents/lectures/:id/students',  ['LectureStudentController', 'getLecturesStudents']);
    $router->post('/lecturestudents',  ['LectureStudentController', 'save']);
    $router->patch('/lecturestudents/lectures/:id/students/:id',  ['LectureStudentController', 'update']);
    $router->delete('/lecturestudents/lectures/:id/students/:id',  ['LectureStudentController', 'delete']);


    // Routes for LectureTeacherController
    $router->get('/lectureteachers',  ['LectureTeacherController', 'getAll']);
    $router->get('/lectureteachers/lectures/:id/teachers/:id',  ['LectureTeacherController', 'getOne']);
    $router->post('/lectureteachers',  ['LectureTeacherController', 'save']);
    $router->patch('/lectureteachers/lectures/:id/teachers/:id',  ['LectureTeacherController', 'update']);
    $router->delete('/lectureteachers/lectures/:id/teachers/:id',  ['LectureTeacherController', 'delete']);


    // Routes for MedicalInfoController
    $router->get('/medicalinfos',  ['MedicalInfoController', 'getAll']);
    $router->get('/medicalinfos/:id',  ['MedicalInfoController', 'getOne']);
    $router->post('/medicalinfos',  ['MedicalInfoController', 'save']);
    $router->patch('/medicalinfos/:id',  ['MedicalInfoController', 'update']);
    $router->delete('/medicalinfos/:id',  ['MedicalInfoController', 'delete']);


    // Routes for PersonalInfoController
    $router->get('/personalinfos',  ['PersonalInfoController', 'getAll']);
    $router->get('/personalinfos/:id',  ['PersonalInfoController', 'getOne']);
    $router->post('/personalinfos',  ['PersonalInfoController', 'save']);
    $router->patch('/personalinfos/:id',  ['PersonalInfoController', 'update']);
    $router->delete('/personalinfos/:id',  ['PersonalInfoController', 'delete']);


    // Routes for RequestCopyController
    $router->get('/requestcopys',  ['RequestCopyController', 'getAll']);
    $router->get('/requestcopys/:id',  ['RequestCopyController', 'getOne']);
    $router->post('/requestcopys',  ['RequestCopyController', 'save']);
    $router->patch('/requestcopys/:id',  ['RequestCopyController', 'update']);
    $router->delete('/requestcopys/:id',  ['RequestCopyController', 'delete']);


    // Routes for StudentController
    $router->get('/students',  ['StudentController', 'getAll']);
    $router->get('/students/:id',  ['StudentController', 'getOne']);
    $router->post('/students',  ['StudentController', 'save']);
    $router->patch('/students/:id',  ['StudentController', 'update']);
    $router->delete('/students/:id',  ['StudentController', 'delete']);


    // Routes for SubscriptionInfoController
    $router->get('/subscriptioninfos',  ['SubscriptionInfoController', 'getAll']);
    $router->get('/subscriptioninfos/:id',  ['SubscriptionInfoController', 'getOne']);
    $router->post('/subscriptioninfos',  ['SubscriptionInfoController', 'save']);
    $router->patch('/subscriptioninfos/:id',  ['SubscriptionInfoController', 'update']);
    $router->delete('/subscriptioninfos/:id',  ['SubscriptionInfoController', 'delete']);


    // Routes for SupervisorController
    $router->get('/supervisors',  ['SupervisorController', 'getAll']);
    $router->get('/supervisors/:id',  ['SupervisorController', 'getOne']);
    $router->post('/supervisors',  ['SupervisorController', 'save']);
    $router->patch('/supervisors/:id',  ['SupervisorController', 'update']);
    $router->delete('/supervisors/:id',  ['SupervisorController', 'delete']);


    // Routes for TeacherController
    $router->get('/teachers',  ['TeacherController', 'getAll']);
    $router->get('/teachers/:id',  ['TeacherController', 'getOne']);
    $router->post('/teachers',  ['TeacherController', 'save']);
    $router->patch('/teachers/:id',  ['TeacherController', 'update']);
    $router->delete('/teachers/:id',  ['TeacherController', 'delete']);


    // Routes for TeamAccomplishmentController
    $router->get('/teamaccomplishments',  ['TeamAccomplishmentController', 'getAll']);
    $router->get('/teamaccomplishments/:id',  ['TeamAccomplishmentController', 'getOne']);
    $router->post('/teamaccomplishments',  ['TeamAccomplishmentController', 'save']);
    $router->patch('/teamaccomplishments/:id',  ['TeamAccomplishmentController', 'update']);
    $router->delete('/teamaccomplishments/:id',  ['TeamAccomplishmentController', 'delete']);


    // Routes for TeamAccomplishmentStudentController
    $router->get('/teamaccomplishmentstudents',  ['TeamAccomplishmentStudentController', 'getAll']);
    $router->get('/teamaccomplishmentstudents/teamaccomplishments/:id/students/:id',  ['TeamAccomplishmentStudentController', 'getOne']);
    $router->post('/teamaccomplishmentstudents',  ['TeamAccomplishmentStudentController', 'save']);
    $router->patch('/teamaccomplishmentstudents/teamaccomplishments/:id/students/:id',  ['TeamAccomplishmentStudentController', 'update']);
    $router->delete('/teamaccomplishmentstudents/teamaccomplishments/:id/students/:id',  ['TeamAccomplishmentStudentController', 'delete']);


    // Routes for WeeklyScheduleController
    $router->get('/weeklyschedules',  ['WeeklyScheduleController', 'getAll']);
    $router->get('/weeklyschedules/:id',  ['WeeklyScheduleController', 'getOne']);
    $router->post('/weeklyschedules',  ['WeeklyScheduleController', 'save']);
    $router->patch('/weeklyschedules/:id',  ['WeeklyScheduleController', 'update']);
    $router->delete('/weeklyschedules/:id',  ['WeeklyScheduleController', 'delete']);


    // Routes for StudentLectureAchievementsController
    $router->get('/achievements',  ['StudentLectureAchievementsController', 'getAll']);
    $router->get('/achievements/latest',  ['StudentLectureAchievementsController', 'getLatest']);
    $router->get('/achievements/lectures/:id/students/:id',  ['StudentLectureAchievementsController', 'getOne']);
    $router->post('/achievements',  ['StudentLectureAchievementsController', 'save']);
    $router->patch('/achievements/lectures/:id/students/:id',  ['StudentLectureAchievementsController', 'update']);
    $router->delete('/achievements/lectures/:id/students/:id',  ['StudentLectureAchievementsController', 'delete']);



    // Routes for AttendanceController
    // Get all attendance records
    $router->get('/attendances', ['SupervisorAttendanceController', 'getAll']);

    // Get attendance by supervisor ID and date (composite key)
    $router->get('/attendances/date/:date/supervisor/:supervisorId', ['SupervisorAttendanceController', 'getBySupervisorAndDate']);

    // Get all records for a specific supervisor
    $router->get('/attendances/supervisor/:supervisorId', ['SupervisorAttendanceController', 'getBySupervisorId']);

    // Get all records for a specific date
    $router->get('/attendances/date/:date', ['SupervisorAttendanceController', 'getByDate']);

    // Create a single attendance record
    $router->post('/attendances', ['SupervisorAttendanceController', 'save']);

    // Update an attendance record by supervisor ID and date
    $router->patch('/attendances/:supervisorId/:date', ['SupervisorAttendanceController', 'update']);

    // Delete an attendance record by supervisor ID and date
    $router->delete('/attendances/:supervisorId/:date', ['SupervisorAttendanceController', 'delete']);

}

{
    /////////////////////
    // special routes
    /////////////////////
    $router->get('/special/students', ['S_StudentController', 'getAllStudents']);
    $router->post('/special/students/submit', ['S_StudentController', 'saveNewStudent']);
    $router->put('/special/students/:id', ['S_StudentController', 'updateStudent']);

    $router->get('/special/guardians', ['S_GuardianController', 'getAllGuardians']);
    $router->post('/special/guardians/submit', ['S_GuardianController', 'saveNewGuardian']);
    $router->put('/special/guardians/:id', ['S_GuardianController', 'updateGuardian']);

    $router->get('/special/lectures', ['S_LectureController', 'getAllLectures']);
    $router->post('/special/lectures/submit', ['S_LectureController', 'saveNewLecture']);
    $router->put('/special/lectures/:id', ['S_LectureController', 'updateLecture']);

    $router->get('/special/exams-records', ['S_ExamRecordsController', 'getAllExams']);
    $router->post('/special/exams-records/submit', ['S_ExamRecordsController', 'saveNewExam']);
    $router->put('/special/exams-records/:id', ['S_ExamRecordsController', 'updateExam']);

    $router->get('/special/exams-teachers', ['S_ExamTeachersController', 'getAllExams']);
    $router->post('/special/exams-teachers/submit', ['S_ExamTeachersController', 'saveNewExam']);
    $router->put('/special/exams-teachers/:id', ['S_ExamTeachersController', 'updateExam']);
}


$router->run(); // Initialize database connection
