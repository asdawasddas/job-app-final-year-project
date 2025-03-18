import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../base/api_routes.dart';

class AccountService {
  static Future<http.Response> getAccountInfo(String token, String id) {
    return http.get(
      Uri.parse(ApiRoutes.hirerInfo(id)),
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
      Uri.parse(ApiRoutes.hirerAvatar(id)),
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
      Uri.parse(ApiRoutes.hirerAvatar(id)),
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
        'POST', Uri.parse(ApiRoutes.hirerAvatar(id)),
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
      // request.fields.addAll({
      //   "name":"test",
      //   "email":"test@gmail.com",
      //   "id":"12345"
      // });
      request.headers.addAll(headers);
      return request.send();
  }

  static Future<http.Response> changePassword(String token, String id, Map<String, dynamic> data) {
    return http.post
    (
      Uri.parse(ApiRoutes.hirerChangePassword(id)),
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
      Uri.parse(ApiRoutes.hirerInfo(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> statistic(String token, String id) {
    return http.get
    (
      Uri.parse(ApiRoutes.hirerStatistic(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }
}