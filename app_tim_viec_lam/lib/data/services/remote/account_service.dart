import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../base/api_routes.dart';

class AccountService {
  static Future<http.Response> getInfo(String token, String id) {
    return http.get(
      Uri.parse(ApiRoutes.applicantInfo(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }

  static Future<http.Response> deleteAvatar(String token, String id) {
    return http.delete
    (
      Uri.parse(ApiRoutes.applicantAvatar(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }

  static Future<http.Response> changeAvatarUrl(String token, String id, Map<String, dynamic> data) {
    return http.put
    (
      Uri.parse(ApiRoutes.applicantAvatar(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.StreamedResponse> changeAvatar(String token, String id, File file) {
      var request = http.MultipartRequest(
        'POST', Uri.parse(ApiRoutes.applicantAvatar(id)),
      );
      Map<String,String> headers={
        "Content-type": "multipart/form-data",
        'Authorization': token,
      };
      
      request.files.add(
          http.MultipartFile(
             'image',
              file.readAsBytes().asStream(),
              file.lengthSync(),
              filename: id
          ),
      );
      request.headers.addAll(headers);
      return request.send();
  }

  static Future<http.Response> changePassword(String token, String id, Map<String, dynamic> data) {
    return http.put
    (
      Uri.parse(ApiRoutes.applicantChangePassword(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> updateInfo(String token, String id, Map<String, dynamic> data) {
    return http.put
    (
      Uri.parse(ApiRoutes.applicantInfo(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.StreamedResponse> apply(String token, String jobId, File file) {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiRoutes.jobDetail(jobId)),
      );
      Map<String,String> headers={
        "Content-type": "multipart/form-data",
        'Authorization': token,
      };
      
      request.files.add(
          http.MultipartFile(
             'cv',
              file.readAsBytes().asStream(),
              file.lengthSync(),
              filename: jobId
          ),
      );
      request.headers.addAll(headers);
      return request.send();
  }
}