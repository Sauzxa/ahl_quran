import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/model.dart';

class Supervisor implements Model {
  dynamic supervisorId;
  dynamic firstName;
  dynamic lastName;
  dynamic supervisorAccountId;
  dynamic profileImage;

  Supervisor({
    this.supervisorId,
    this.firstName,
    this.lastName,
    this.supervisorAccountId,
    this.profileImage,
  });

  factory Supervisor.fromJson(Map<String, dynamic> json) => Supervisor(
        supervisorId: json['supervisor_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        supervisorAccountId: json['supervisor_account_id'],
        profileImage: json['profile_image'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'supervisor_id': supervisorId,
        'first_name': firstName,
        'last_name': lastName,
        'supervisor_account_id': supervisorAccountId,
        'profile_image': profileImage,
      };

  @override
  bool get isComplete =>
      supervisorId != null &&
      firstName != null &&
      lastName != null &&
      supervisorAccountId != null;
}
