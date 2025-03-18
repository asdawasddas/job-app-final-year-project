import 'dart:async';

import 'package:http/http.dart' as http;
import '../base/api_routes.dart';

class EnterpriseService {
  static Future<http.Response> search(String searchTxt) {
      String url = ApiRoutes.enterprises + '?search=$searchTxt';
      return http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );
  }

  static Future<http.Response> favEnterprises(String applicantId, String token) {
    return http.get(
      Uri.parse(ApiRoutes.applicantFavEnterprise(applicantId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }
  
  static Future<http.Response> getInfo(String id) {
    return http.get(
      Uri.parse(ApiRoutes.enterpriseDetail(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
  }
}