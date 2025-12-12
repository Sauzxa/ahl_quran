import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/forms/account_info.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/contact_info.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/formal_education_info.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/guardian.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/medical_info.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/personal_info.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/student_relations.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/lecture.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/subscription_info.dart';

class Student implements Model {
  PersonalInfo personalInfo = PersonalInfo();
  AccountInfo accountInfo = AccountInfo();
  ContactInfo contactInfo = ContactInfo();
  MedicalInfo medicalInfo = MedicalInfo();
  Guardian guardian = Guardian();
  List<Lecture> lectures = [];
  StudentRelations student = StudentRelations();
  FormalEducationInfo formalEducationInfo = FormalEducationInfo();
  SubscriptionInfo subscriptionInfo = SubscriptionInfo();

  // Constructor for empty form initialization
  Student();

  @override
  // Method to check if all required fields are filled
  bool get isComplete {
    return (personalInfo.firstNameAr != null &&
            personalInfo.firstNameAr!.isNotEmpty) &&
        (personalInfo.lastNameAr != null &&
            personalInfo.lastNameAr!.isNotEmpty) &&
        (personalInfo.sex != null && personalInfo.sex!.isNotEmpty) &&
        (accountInfo.username != null && accountInfo.username!.isNotEmpty) &&
        (accountInfo.passcode != null && accountInfo.passcode!.isNotEmpty) &&
        (contactInfo.phoneNumber != null &&
            contactInfo.phoneNumber!.isNotEmpty) &&
        (contactInfo.email != null && contactInfo.email.isNotEmpty);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'personalInfo': personalInfo.toJson(),
      'accountInfo': accountInfo.toJson(),
      'contactInfo': contactInfo.toJson(),
      'medicalInfo': medicalInfo.toJson(),
      'guardian': guardian.toJson(),
      'student': student.toJson(),
      'lectures': lectures.map((lecture) => lecture.toJson()).toList(),
      'formalEducationInfo': formalEducationInfo.toJson(),
      'subscriptionInfo': subscriptionInfo.toJson(),
    };
  }

  static Student fromJson(Map<String, dynamic> json) {
    return Student()
      ..personalInfo = PersonalInfo.fromJson(json['personalInfo'])
      ..accountInfo = AccountInfo.fromJson(json['accountInfo'])
      ..contactInfo = ContactInfo.fromJson(json['contactInfo'])
      ..medicalInfo = MedicalInfo.fromJson(json['medicalInfo'])
      ..guardian = Guardian.fromJson(json['guardian'])
      ..student = StudentRelations.fromJson(json['student'])
      ..lectures = (json['lectures'] as List)
          .map((lecture) => Lecture.fromJson(lecture))
          .toList()
      ..formalEducationInfo =
          FormalEducationInfo.fromJson(json['formalEducationInfo'])
      ..subscriptionInfo = SubscriptionInfo.fromJson(json['subscriptionInfo']);
  }
}
