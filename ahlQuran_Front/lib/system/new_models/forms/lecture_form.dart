import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/lecture.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/teacher.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/weekly_schedule.dart';

class LectureForm implements Model {
  //lecture info
  //required
  late Lecture lecture = Lecture();
  late List<Teacher> teachers = [];
  //lecture schedule
  late List<WeeklySchedule> schedules;
  int studentCount;

  LectureForm(
      {Lecture? lecture,
      List<Teacher>? teachers,
      List<WeeklySchedule>? schedules,
      this.studentCount = 0})
      : lecture = lecture ?? Lecture(),
        teachers = teachers ?? [],
        schedules = schedules ?? [];

  static var fromJson = (Map<String, dynamic> json) {
    return LectureForm(studentCount: json['student_count'] ?? 0)
      ..lecture = Lecture.fromJson(json['lecture'] ?? {})
      ..teachers = (json['teachers'] as List<dynamic>? ?? [])
          .map((t) => Teacher.fromJson(t))
          .toList()
      ..schedules = (json['schedules'] as List<dynamic>? ?? [])
          .map((s) => WeeklySchedule.fromJson(s))
          .toList();
  };

  @override
  bool get isComplete {
    return lecture.lectureNameAr.isNotEmpty &&
        lecture.lectureNameEn.isNotEmpty &&
        lecture.circleType.isNotEmpty &&
        teachers.isNotEmpty &&
        schedules.isNotEmpty;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "lecture": {
        "lecture_id": lecture.lectureId,
        "lecture_name_ar": lecture.lectureNameAr,
        "lecture_name_en": lecture.lectureNameEn,
        "circle_type": lecture.circleType,
        "shown_on_website": lecture.shownOnWebsite
      },
      "teachers": teachers.map((t) => t.toJson()).toList(),
      "schedules": schedules.map((s) => s.toJson()).toList(),
      "student_count": studentCount,
    };
  }
}
