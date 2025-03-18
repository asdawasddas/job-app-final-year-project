import 'dart:convert';
import 'package:job_app_admin/data/model/admin_model.dart';

import '../base/api_routes.dart';
import '../base/status_model.dart';
import '../sercure_storage_srv.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  static Future<Status> authenticate() async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, );
    } else {
      final response = await http.get(
        Uri.parse(ApiRoutes.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return Status(isSuccess: true, data: responseData['id']);
      } else  {
        return Status(isSuccess: false);
      } 
    }
  }

  static Future<Status> login(data) async {
      final response = await http.post(
        Uri.parse(ApiRoutes.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        await AuthStorageService.logIn(token :responseData['token']);
        return Status(isSuccess: true, data: responseData['id']);
      } else if (response.statusCode == 401) {
        return Status(isSuccess: false, failMsg: 'Tên tài khoản hoặc mật khẩu không đúng');
      } else {
        return Status(isSuccess: false);
      }
  }

  static logOut() async{
    await AuthStorageService.logOut();
  }

  static Future<Status> getInfo(String adminId) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, );
    } else {
      final response = await http.get(
        Uri.parse(ApiRoutes.adminInfo(adminId)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        return Status(isSuccess: true, data: Admin.fromJson(responseData));
      } else {
        return Status(isSuccess: false);
      }
    }
  }

  static Future<Status> changePassword(String adminId, Map<String,dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, );
    } else {
      final response = await http.put(
        Uri.parse(ApiRoutes.adminChangePassword(adminId)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': token,
        },
      );
      if (response.statusCode == 200) {
        return Status(isSuccess: true,);
      } else {
        return Status(isSuccess: false);
      }
    }
  }

  static Future<Status> update(String adminId, Map<String,dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, );
    } else {
      final response = await http.put(
        Uri.parse(ApiRoutes.adminInfo(adminId)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return Status(isSuccess: true,);
      } else {
        return Status(isSuccess: false);
      }
    }
  }
}