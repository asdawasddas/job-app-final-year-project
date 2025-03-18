
class ApplicantModel {
   String id;
   String fullName;
   String email;
   String phoneNumber;
   String avatarUrl;
   bool isBlocked;

  ApplicantModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.isBlocked
  });

  static ApplicantModel fromJson(Map<String, dynamic>json) {
    return ApplicantModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      isBlocked: json['is_blocked'] ?? false,
    );
  }
}