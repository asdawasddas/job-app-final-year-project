import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../base/api_routes.dart';

class ApplicationService {
  static Future<http.Response> getJobApplications(String token, String jobId, int sort) {
    return http.get(
      Uri.parse('${ApiRoutes.jobApplications(jobId)}?sort=$sort'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }

  static Future<http.Response> update(String token, String applicationId, Map<String, dynamic> data) {
    return http.put
    (
      Uri.parse(ApiRoutes.applicationDetail(applicationId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(data),
    );
  }
}