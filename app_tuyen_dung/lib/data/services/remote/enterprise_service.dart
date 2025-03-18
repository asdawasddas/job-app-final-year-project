import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
  
  static Future<http.Response> getInfo(String id) {
    return http.get(
      Uri.parse(ApiRoutes.enterpriseInfo(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
  }

  static Future<http.Response> deleteLogo(String token, String id) {
    return http.delete
    (
      Uri.parse(ApiRoutes.enterpriseLogo(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }

  static Future<http.StreamedResponse> changeLogo(String token, String id, File file) {
      var request = http.MultipartRequest(
        'POST', Uri.parse(ApiRoutes.enterpriseLogo(id)),
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

  static Future<http.Response> updateInfo(String token, String id, Map<String, dynamic> data) {
    return http.put
    (
      Uri.parse(ApiRoutes.enterpriseInfo(id)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(data),
    );
  }
}