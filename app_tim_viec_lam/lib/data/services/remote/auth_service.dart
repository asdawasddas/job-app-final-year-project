import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../base/api_routes.dart';

class AuthService {
  static Future<http.Response> authenticate(String token) {
    return http.get(
      Uri.parse(ApiRoutes.login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
  }

  static Future<http.Response> login(Map<String, dynamic> loginData) {
    return http.post(
        Uri.parse(ApiRoutes.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginData),
    );
  }

  static Future<http.Response> signUp(Map<String, dynamic> signUpData) {
    return http.post(
      Uri.parse(ApiRoutes.signUp),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(signUpData),
    );
  }
}