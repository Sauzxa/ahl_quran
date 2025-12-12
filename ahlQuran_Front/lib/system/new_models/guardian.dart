import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';

class Guardian implements Model {
  dynamic guardianId;
  dynamic firstName;
  dynamic lastName;
  dynamic dateOfBirth;
  dynamic relationship;
  dynamic guardianContactId;
  dynamic guardianAccountId;
  dynamic homeAddress;
  dynamic job;
  dynamic profileImage;

  Guardian({
    this.guardianId,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.relationship,
    this.guardianContactId,
    this.guardianAccountId,
    this.homeAddress,
    this.job,
    this.profileImage,
  });

  factory Guardian.fromJson(Map<String, dynamic> json) => Guardian(
        guardianId: json['guardian_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        dateOfBirth: json['date_of_birth'],
        relationship: json['relationship'],
        guardianContactId: json['guardian_contact_id'],
        guardianAccountId: json['guardian_account_id'],
        homeAddress: json['home_address'],
        job: json['job'],
        profileImage: json['profile_image'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'guardian_id': guardianId,
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': dateOfBirth,
        'relationship': relationship,
        'guardian_contact_id': guardianContactId,
        'guardian_account_id': guardianAccountId,
        'home_address': homeAddress,
        'job': job,
        'profile_image': profileImage,
      };

  @override
  String toString() {
    return '[ $guardianId ] - $firstName $lastName ';
  }

  @override
  bool get isComplete {
    return guardianId != null &&
        firstName != null &&
        lastName != null &&
        dateOfBirth != null &&
        relationship != null &&
        guardianContactId != null &&
        guardianAccountId != null &&
        homeAddress != null &&
        job != null &&
        profileImage != null;
  }
}
