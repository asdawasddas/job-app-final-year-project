
//* status CV :
// 0: Chưa Đánh giá
// 1: Không đạt vòng lọc CV
// 2: Đạt vòng lọc CV
// 3: Không đạt vòng phỏng vấn
// 4: Đạt vòng phỏng vấn *//

class Application {
  String id;
  String jobId;
  String hirerId;
  String applicantId;
  String cvUrl;
  int status;
  String appliedTime;
  String applicantName;
  String applicantEmail;
  String applicantPhone;
  String applicantAvatarUrl;

  Application({
    required this.id,
    required this.jobId,
    required this.hirerId,
    required this.applicantId,
    required this.cvUrl,
    required this.status,
    required this.appliedTime,
    required this.applicantName,
    required this.applicantEmail,
    required this.applicantPhone,
    required this.applicantAvatarUrl,
  });

  static Application fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] ?? '',
      jobId: json['job_id'] ?? '',
      hirerId: json['hirer_id'] ?? '',
      applicantId: json['applicant_id'] ?? '',
      cvUrl: json['cv_url'] ?? '',
      status: json['status'] ?? 0,
      appliedTime: json['applied_time'] ?? '',
      applicantName: json['applicant_name'] ?? '',
      applicantEmail: json['applicant_email'] ?? '',
      applicantPhone: json['applicant_phone'] ?? '',
      applicantAvatarUrl: json['applicant_avatar_url'] ?? '',
    );
  }

  String get getStatus {
    if (status == 0) {
      return 'Chưa đánh giá';
    }
    if (status == 1) {
      return 'CV không đạt yêu cầu';
    }
    if (status == 2) {
      return 'CV đạt yêu cầu';
    }
    if (status == 3) {
      return 'Không đạt phỏng vấn';
    }
    if (status == 4) {
      return 'Đạt phỏng vấn';
    }
    return 'Không xác định';
  }

  void update(Map<String, dynamic> updateData) {
    status = updateData['status'] ?? status;
  }
}