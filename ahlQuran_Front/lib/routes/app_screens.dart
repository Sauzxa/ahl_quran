import 'package:get/get.dart';

// Import bindings
import 'package:the_doctarine_of_the_ppl_of_the_quran/bindings/copy.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/bindings/management_binding.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/bindings/acheivement.dart';
//import 'package:the_doctarine_of_the_ppl_of_the_quran/bindings/starter.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/bindings/attendance_binding.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/bindings/charts/stat1_binding.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/bindings/charts/stat2_binding.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/bindings/charts/stat3_binding.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/forms/exam_records_form.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/forms/exam_teachers_from.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/forms/guardian_form.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/forms/lecture_form.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/student.dart'
    as student;
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/appreciation.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/exam.dart';
//import 'package:the_doctarine_of_the_ppl_of_the_quran/bindings/exam_teacher_binding.dart'; // Assuming this is correct

// Import screens
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exam_management.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exams/exam_notes.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exams/exam_records.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exams/exam_teachers.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exams/exam_types.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/web/pages/copy.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/student_managment.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/guardian_managment.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/lecture_managment.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/achievement_managment.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/login.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/attendance/attendance.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/testpage.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/flipcard.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/onboarding.dart';

// Report screens (namespaced)
import '../screens/report1_screen.dart' as report1;
import '../screens/report2_screen.dart' as report2;
import '../screens/report3_screen.dart' as report3;
import '../screens/report4_screen.dart' as report4;

// Stats screens
import 'package:the_doctarine_of_the_ppl_of_the_quran/stats/stat1.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/stats/stat2.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/stats/stat3.dart';

// Utility screens
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/forget_password.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/create_account.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/landing.dart';
// App routes
import 'package:the_doctarine_of_the_ppl_of_the_quran/routes/app_routes.dart';

//web
import 'package:the_doctarine_of_the_ppl_of_the_quran/web/pages/features.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/web/pages/home.dart';

import 'package:the_doctarine_of_the_ppl_of_the_quran/web/pages/pricing.dart';
import '../middleware/auth_middleware.dart';

class AppScreens {
  static final routes = [
    GetPage(
      name: Routes.copy,
      page: () => CopyPage(),
      binding: CopyBinding(),
    ),
    GetPage(
      name: Routes.addStudent,
      page: () => AddStudent(),
      binding: ManagementBinding<student.Student>(
          fromJson: student.Student.fromJson),
    ),
    GetPage(
      name: Routes.addGuardian,
      page: () => AddGuardian(),
      binding: ManagementBinding<GuardianInfoDialog>(
          fromJson: GuardianInfoDialog.fromJson),
    ),
    GetPage(
      name: Routes.addLecture,
      page: () => AddLecture(),
      binding: ManagementBinding<LectureForm>(fromJson: LectureForm.fromJson),
    ),
    GetPage(
      name: Routes.addAchievement,
      page: () => AddAcheivement(),
      binding: AcheivementBinding(),
    ),
    GetPage(
      name: Routes.test,
      page: () => TestPage(),
    ),
    GetPage(
      name: Routes.logIn,
      page: () => LogInPage(),
    ),
    GetPage(
      name: Routes.attendance,
      page: () => AttendanceScreen(),
      binding: AttendanceBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.initial,
      page: () => const DashboardPage(),
    ),

    // Report screens
    GetPage(name: Routes.report1, page: () => report1.Report1Screen()),
    GetPage(name: Routes.report2, page: () => report2.Report2Screen()),
    GetPage(name: Routes.report3, page: () => report3.Report3Screen()),
    GetPage(name: Routes.report4, page: () => report4.Report4Screen()),

    // Utility screens
    GetPage(name: Routes.test, page: () => const TestPage()),
    GetPage(name: Routes.card, page: () => const StudentSelectionPage()),

    // Exam related screens with bindings
    GetPage(
      name: Routes.examPage,
      page: () => ExamPage(),
    ),
    GetPage(
      name: Routes.examTypes,
      page: () => ExamTypes(),
      binding: ManagementBinding<Exam>(fromJson: Exam.fromJson),
    ),
    GetPage(
      name: Routes.examRecords,
      page: () => ExamRecords(),
      binding: ManagementBinding<ExamRecordInfoDialog>(
          fromJson: ExamRecordInfoDialog.fromJson),
    ),
    GetPage(
      name: Routes.examNotes,
      page: () => ExamNotes(),
      binding: ManagementBinding<Appreciation>(fromJson: Appreciation.fromJson),
    ),
    GetPage(
      name: Routes.examTeachers,
      page: () => ExamTeachers(),
      binding: ManagementBinding<ExamTeacherInfoDialog>(
          fromJson: ExamTeacherInfoDialog.fromJson),
    ),

    /*GetPage(
      name: Routes.financialManagement,
      page: () => ,
      
    ),*/

    // Stats screens
    GetPage(
      name: Routes.stat1,
      page: () => StudentProgressChartScreen(),
      binding: Stat1Binding(),
    ),
    GetPage(
      name: Routes.stat2,
      page: () => AttendanceChartScreen(),
      binding: Stat2Binding(),
    ),
    GetPage(
      name: Routes.stat3,
      page: () => PerformanceChartScreen(),
      binding: Stat3Binding(),
    ),

    // User account related
    GetPage(
      name: Routes.createAccount,
      page: () => CreateAccountScreen(),
    ),
    GetPage(
      name: Routes.forgetPassword,
      page: () => ForgetPasswordScreen(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => OnboardingScreen(),
    ),
    GetPage(
      name: Routes.dashboardPage,
      page: () => DashboardPage(),
    ),

    GetPage(
      name: WebRoutes.home,
      page: () => HomePage(),
    ),
    GetPage(
      name: WebRoutes.pricing,
      page: () => PricingPage(),
    ),
    GetPage(
      name: WebRoutes.features,
      page: () => FeaturesPage(),
    ),
  ];
}
