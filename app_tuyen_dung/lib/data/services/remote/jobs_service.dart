import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../base/api_routes.dart';

class JobsService {
  static Future<http.Response> hirerJobs(String hirerId, int sort) {
    return http.get(
      Uri.parse('${ApiRoutes.hirerJobs(hirerId)}?sort=$sort'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
  }

  static Future<http.Response> create(String token, Map<String, dynamic> data) {
    return http.post
    (
      Uri.parse(ApiRoutes.jobs),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> update(String token, String jobId, Map<String, dynamic> data) {
    return http.put
    (
      Uri.parse(ApiRoutes.jobDetail(jobId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> close(String token, String jobId) {
    return http.delete
    (
      Uri.parse(ApiRoutes.jobDetail(jobId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }
}