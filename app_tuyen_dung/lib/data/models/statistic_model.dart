
class Statistic {
  final int totalJob;
  final int runningJob;
  final int totalCV;
  final int newCV;

  Statistic({required this.totalJob, required this.runningJob, required this.totalCV, required this.newCV});

  static Statistic fromJson(Map<String, dynamic> json) {
    return Statistic(
      totalJob: json['total_job'] ?? 0, 
      runningJob: json['running_job'] ?? 0,
      totalCV: json['total_cv'] ?? 0,
      newCV: json['new_cv'] ?? 0
    );
  }
}