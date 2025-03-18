import 'dart:convert';

import 'package:app_tuyen_dung/data/models/hirer_account_model.dart';
import 'package:app_tuyen_dung/data/models/statistic_model.dart';

import '../base/status_model.dart';
import '../services/remote/account_service.dart';
import '../services/local/auth_storage_service.dart';
import 'dart:io';

class AccountRepo {

  static Future<Status> getAccountInfo(String id) async {
    final String? token = await AuthStorageService.getToken();

    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await AccountService.getAccountInfo(token, id);
        if (response.statusCode == 200) {
          final responseData = json.decode(utf8.decode(response.bodyBytes));
          return Status(isSuccess: true, data: HirerAccountModel.fromJson(responseData));
        } else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> statistic(String id) async {
    final String? token = await AuthStorageService.getToken();

    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await AccountService.statistic(token, id);
        if (response.statusCode == 200) {
          final responseData = json.decode(utf8.decode(response.bodyBytes));
          return Status(isSuccess: true, data: Statistic.fromJson(responseData));
        } else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> deleteAvatar(String id) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await AccountService.deleteAvatar(token, id);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        } else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> changeAvatarUrl(String id, Map<String, dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await AccountService.changeAvatarUrl(token, id, data);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        } else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> changeAvatar(String id, File file) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await AccountService.changeAvatar(token, id, file);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        } else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> changePassword(String id, Map<String, dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await AccountService.changePassword(token, id, data);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        } else if (response.statusCode == 401) {
          return Status(isSuccess: false, failMsg: 'Mật khẩu hiện tại không đúng');
        }
        else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> updateInfo(String id, Map<String, dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await AccountService.updateInfo(token, id, data);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        }
        else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }
}