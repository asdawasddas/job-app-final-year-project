import 'dart:async';

import 'package:http/http.dart' as http;
import '../base/api_routes.dart';

class JobService {
  static Future<http.Response> jobs(String searchTxt) {
    String url = '${ApiRoutes.jobs}?$searchTxt';
    return http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
  }

  static Future<http.Response> favJobs(String applicantId, String token) {
    return http.get(
      Uri.parse(ApiRoutes.applicantFavJob(applicantId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }

  static Future<http.Response> favEnterpriseJobs(String applicantId, String token) {
    return http.get(
      Uri.parse(ApiRoutes.applicantFavEnterpriseJob(applicantId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }

  static Future<http.Response> enterpriseJobs(String enterpriseId) {
    return http.get(
      Uri.parse(ApiRoutes.enterpriseJobs(enterpriseId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
  }

  static Future<http.Response> getInfo(String id) {
    return http.get(
      Uri.parse(ApiRoutes.jobDetail(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
  }
}