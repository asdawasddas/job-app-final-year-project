
class Applicant {
   String id;
   String fullName;
   String email;
   String phoneNumber;
   String avatarUrl;
   List favJobs;
   List favEnterprise;
   List appliedJobs;
   bool isBlocked;

  Applicant({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.favJobs,
    required this.favEnterprise,
    required this.appliedJobs,
    required this.isBlocked
  });

  String get status {
    return isBlocked ? 'Bị chặn' : 'Bình thường';
  }

  static Applicant fromJson(Map<String, dynamic>json) {
    return Applicant(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      favJobs: json['fav_jobs'] ?? [],
      favEnterprise: json['fav_enterprises'] ?? [],
      appliedJobs: json['applied_jobs'] ?? [],
      isBlocked :  json['is_blocked'] ?? false
    );
  }

  void update(Map<String, dynamic>json) {
      fullName = json['full_name'] ?? fullName;
      phoneNumber = json['phone_number'] ?? phoneNumber;
  }

  void updateFavJob(jobId) {
    if (favJobs.contains(jobId)) {
      favJobs.removeWhere((item) => item == jobId);
    } else {
      favJobs.add(jobId);
    }
  }

  void updateFavEnterprise(enterpriseId) {
    if (favEnterprise.contains(enterpriseId)) {
      favEnterprise.removeWhere((item) => item == enterpriseId);
    } else {
      favEnterprise.add(enterpriseId);
    }
  }

  void updateAppliedJob(jobId) {
    appliedJobs.add('applied_job_id');
  }
}