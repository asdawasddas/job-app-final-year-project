import 'dart:async';

import 'package:http/http.dart' as http;
import '../base/api_routes.dart';

class ApplicationService {
  static Future<http.Response> applicantApplications(String applicantId, String token) {
    String url = ApiRoutes.applicantApplication(applicantId);
    return http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }

  static Future<http.Response> jobApplication(String jobId, String token) {
    return http.get(
      Uri.parse(ApiRoutes.jobApplication(jobId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }
}