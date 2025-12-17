/// API Configuration
/// Configure your backend server IP and port here
class ApiConfig {
  // Backend server IP address (use localhost for Chrome development)
  static const String ip = 'localhost';

  // Backend server port (80 for HTTP, 443 for HTTPS, or custom port)
  static const String port = '8000';

  // API path on the server
  static const String apiPath = 'api/v1';

  // Use HTTPS instead of HTTP
  static const bool useHttps = false;

  /// Automatically builds the base URL from IP, port, and path
  static String get baseUrl {
    final protocol = useHttps ? 'https' : 'http';
    final defaultPort = useHttps ? '443' : '80';

    // Don't include port in URL if it's the default port
    if (port == defaultPort || port.isEmpty) {
      return '$protocol://$ip/$apiPath';
    } else {
      return '$protocol://$ip:$port/$apiPath';
    }
  }
}

/// API Endpoints
/// All API endpoints are built using the base URL from ApiConfig
class ApiEndpoints {
  static String get baseUrl => ApiConfig.baseUrl;

  // AccountInfo endpoints
  static final String getAccountInfos = '$baseUrl/accountinfos';
  static String getAccountInfoById(int id) => '$baseUrl/accountinfos/$id';
  static final String login = '$baseUrl/auth/login';
  static final String signup = '$baseUrl/auth/signup';
  static final String logout = '$baseUrl/auth/logout';
  static final String presidentRegister = '$baseUrl/auth/president/register';
  static final String presidentLogin = '$baseUrl/auth/president/login';
  static final String supervisorLogin = '$baseUrl/auth/supervisor/login';
  static final String getCurrentUser = '$baseUrl/auth/me';

  // Appreciation endpoints
  static final String getAppreciations = '$baseUrl/appreciations';
  static String getAppreciationById(int id) => '$baseUrl/appreciations/$id';

  // ContactInfo endpoints
  static final String getContactInfos = '$baseUrl/contactinfos';
  static String getContactInfoById(int id) => '$baseUrl/contactinfos/$id';

  // Exam endpoints
  static final String getExams = '$baseUrl/exams';
  static String getExamById(int id) => '$baseUrl/exams/$id';

  // ExamLevel endpoints
  static final String getExamLevels = '$baseUrl/examlevels';
  static String getExamLevelById(int id) => '$baseUrl/examlevels/$id';

  // ExamStudent endpoints
  static final String getExamStudents = '$baseUrl/examstudents';
  static String getExamStudentById(int examId, int studentId) =>
      '$baseUrl/examstudents/exams/$examId/students/$studentId';

  // ExamTeacher endpoints
  static final String getExamTeachers = '$baseUrl/examteachers';
  static String getExamTeacherById(int examId, int teacherId) =>
      '$baseUrl/examteachers/exams/$examId/teachers/$teacherId';

  static String deleteExamTeacherByTeacherId(int teacherId) =>
      '$baseUrl/examteachers/exams/teachers/$teacherId';

  // FormalEducationInfo endpoints
  static final String getFormalEducationInfos = '$baseUrl/formaleducationinfos';
  static String getFormalEducationInfoById(int id) =>
      '$baseUrl/formaleducationinfos/$id';

  // GoldenRecord endpoints
  static final String getGoldenRecords = '$baseUrl/goldenrecords';
  static String getGoldenRecordById(int id) => '$baseUrl/goldenrecords/$id';

  // Guardian endpoints
  static final String getGuardians = '$baseUrl/guardians/';
  static final String getSpecialGuardians = '$baseUrl/special/guardians';
  static String getSpecialGuardiansById(int id) =>
      '$baseUrl/special/guardians/$id';
  static String getGuardianById(int id) => '$baseUrl/guardians/$id';

  // LectureContent endpoints
  static final String getLectureContents = '$baseUrl/lecturecontents';
  static String getLectureContentById(int id) => '$baseUrl/lecturecontents/$id';

  // Lecture endpoints
  static final String getLectures = '$baseUrl/lectures';
  static final String getSpecialLectures = '$baseUrl/lectures/special/lectures';
  static String getLectureById(int id) =>
      '$baseUrl/lectures/special/lectures/$id';
  static String updateLecture(int id) =>
      '$baseUrl/lectures/special/lectures/$id';
  static String deleteLecture(int id) => '$baseUrl/lectures/$id';

  // LectureStudent endpoints
  static final String getLectureStudents = '$baseUrl/lecturestudents';
  static String getLectureStudentById(int lectureId, int studentId) =>
      '$baseUrl/lecturestudents/lectures/$lectureId/students/$studentId';

  // LectureTeacher endpoints
  static final String getLectureTeachers = '$baseUrl/lectureteachers';
  static String getLectureTeacherById(int lectureId, int teacherId) =>
      '$baseUrl/lectureteachers/lectures/$lectureId/teachers/$teacherId';

  // MedicalInfo endpoints
  static final String getMedicalInfos = '$baseUrl/medicalinfos';
  static String getMedicalInfoById(int id) => '$baseUrl/medicalinfos/$id';

  // PersonalInfo endpoints
  static final String getPersonalInfos = '$baseUrl/personalinfos';
  static String getPersonalInfoById(int id) => '$baseUrl/personalinfos/$id';

  // RequestCopy endpoints
  static final String getRequestCopys = '$baseUrl/requestcopys';
  static String getRequestCopyById(int id) => '$baseUrl/requestcopys/$id';

  // Student endpoints
  static final String getStudents = '$baseUrl/students/';
  static String getStudentById(int id) => '$baseUrl/students/$id';

  // SubscriptionInfo endpoints
  static final String getSubscriptionInfos = '$baseUrl/subscriptioninfos';
  static String getSubscriptionInfoById(int id) =>
      '$baseUrl/subscriptioninfos/$id';

  // Supervisor endpoints
  static final String getSupervisors = '$baseUrl/supervisors';
  static String getSupervisorById(int id) => '$baseUrl/supervisors/$id';

  // Teacher endpoints
  static final String getTeachers = '$baseUrl/teacher';
  static String getTeacherById(int id) => '$baseUrl/teacher/$id';

  // TeamAccomplishment endpoints
  static final String getTeamAccomplishments = '$baseUrl/teamaccomplishments';
  static String getTeamAccomplishmentById(int id) =>
      '$baseUrl/teamaccomplishments/$id';

  // TeamAccomplishmentStudent endpoints
  static final String getTeamAccomplishmentStudents =
      '$baseUrl/teamaccomplishmentstudents';
  static String getTeamAccomplishmentStudentById(int teamId, int studentId) =>
      '$baseUrl/teamaccomplishmentstudents/teamaccomplishments/$teamId/students/$studentId';

  // WeeklySchedule endpoints
  static final String getWeeklySchedules = '$baseUrl/weeklyschedules';

  static String getLatestAchievements = '$baseUrl/achievements/latest';

  static String getGuardianAccounts = '$baseUrl/guardians';

  static String getLectureIdName =
      '$baseUrl/lectures/ar_name-and-id'; //TODO to be removed

  static String getStudentAchievements = '$baseUrl/achievements';

  //static String getSpecialAchievements = '$baseUrl/special/achievements'; doesnt exist

  static String submitStudentForm = '$baseUrl/students/';
  static String submitLectureForm = '$baseUrl/lectures/special/lectures/submit';
  static String getSpecialLecture(int id) => '$baseUrl/special/lectures/$id';

  static String submitGuardianForm = '$baseUrl/guardians/';

  static String getWeeklyScheduleById(int id) => '$baseUrl/weeklyschedules/$id';

  static String getStudentsByLecture(int idLecture) =>
      '$baseUrl/lecturestudents/lectures/$idLecture/students';

  static String getSpecialStudent(int id) => '$baseUrl/students/$id';
  static String updateStudentFull(int id) => '$baseUrl/students/$id/full';

  static String getGuardianByUserName(String? guardianAccountUserName) =>
      '$baseUrl/special/students/$guardianAccountUserName';

  // Special ExamRecords endpoints
  static final String getSpecialExamRecords = '$baseUrl/special/exams-records';
  static final String submitSpecialExamRecord =
      '$baseUrl/special/exams-records/submit';
  static String updateSpecialExamRecord(int id) =>
      '$baseUrl/special/exams-records/$id';

  // Special ExamsTeachers endpoints
  static final String getSpecialExamsTeachers =
      '$baseUrl/special/exams-teachers';
  static final String submitSpecialExamsTeacher =
      '$baseUrl/special/exams-teachers/submit';
  static String updateSpecialExamsTeacher(int id) =>
      '$baseUrl/special/exams-teachers/$id';

  static String uploadImage = '$baseUrl/upload-image';

  static String getSpecialExamRecordsById(int id) =>
      '$baseUrl/special/exams-records/';
}
