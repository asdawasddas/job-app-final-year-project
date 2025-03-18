
//* status CV :
// 0: Chưa Đánh giá
// 1: Không đạt vòng lọc CV
// 2: Đạt vòng lọc CV
// 3: Không đạt vòng phỏng vấn
// 4: Đạt vòng phỏng vấn *//
import 'package:intl/intl.dart';
int daysBetween(DateTime from, DateTime to) {
     from = DateTime(from.year, from.month, from.day);
     to = DateTime(to.year, to.month, to.day);
   return (to.difference(from).inHours / 24).round();
}

class Application {
  String id;
  String jobId;
  String hirerId;
  String applicantId;
  String cvUrl;
  int status;
  String appliedTime;
  String jobTitle;

  Application({
    required this.id,
    required this.jobId,
    required this.hirerId,
    required this.applicantId,
    required this.cvUrl,
    required this.status,
    required this.appliedTime,
    required this.jobTitle,
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
      jobTitle: json['job_title'] ?? '',
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

  int get daysFromAppliedDate {
    final formatter = DateFormat('HH:mm:ss dd-MM-yyyy');
    final date = formatter.parse(appliedTime);
    final now = DateTime.now();
    final dif = daysBetween(date, now);
    return dif;
  }
}