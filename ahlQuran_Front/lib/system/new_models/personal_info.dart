import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';

class PersonalInfo implements Model {
  dynamic studentId;
  dynamic firstNameAr;
  dynamic lastNameAr;
  dynamic firstNameEn;
  dynamic lastNameEn;
  dynamic nationality;
  dynamic sex;
  dynamic dateOfBirth;
  dynamic placeOfBirth;
  dynamic homeAddress;
  dynamic fatherStatus;
  dynamic motherStatus;
  dynamic profileImage;

  PersonalInfo({
    this.studentId,
    this.firstNameAr,
    this.lastNameAr,
    this.firstNameEn,
    this.lastNameEn,
    this.nationality,
    this.sex,
    this.dateOfBirth,
    this.placeOfBirth,
    this.homeAddress,
    this.fatherStatus,
    this.motherStatus,
    this.profileImage,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
        studentId: json['student_id'],
        firstNameAr: json['first_name_ar'],
        lastNameAr: json['last_name_ar'],
        firstNameEn: json['first_name_en'],
        lastNameEn: json['last_name_en'],
        nationality: json['nationality'],
        sex: json['sex'],
        dateOfBirth: json['date_of_birth'],
        placeOfBirth: json['place_of_birth'],
        homeAddress: json['home_address'],
        fatherStatus: json['father_status'],
        motherStatus: json['mother_status'],
        profileImage: json['profile_image'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'first_name_ar': firstNameAr,
        'last_name_ar': lastNameAr,
        'first_name_en': firstNameEn,
        'last_name_en': lastNameEn,
        'nationality': nationality,
        'sex': sex,
        'date_of_birth': dateOfBirth,
        'place_of_birth': placeOfBirth,
        'home_address': homeAddress,
        'father_status': fatherStatus,
        'mother_status': motherStatus,
        'profile_image': profileImage,
      };

  @override
  bool get isComplete =>
      studentId != null &&
      firstNameAr != null &&
      lastNameAr != null &&
      firstNameEn != null &&
      lastNameEn != null &&
      nationality != null &&
      sex != null &&
      dateOfBirth != null &&
      placeOfBirth != null &&
      homeAddress != null &&
      fatherStatus != null &&
      motherStatus != null &&
      profileImage != null;

  String getFullArName() => "$firstNameAr $lastNameAr";
  String getFullEnName() => "$firstNameEn $lastNameEn";

  @override
  String toString() {
    return "${getFullEnName()} - ${getFullArName()}";
  }
}
