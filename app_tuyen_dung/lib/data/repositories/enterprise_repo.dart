import 'dart:convert';

import 'package:app_tuyen_dung/data/models/enterprise_model.dart';
import 'package:app_tuyen_dung/data/services/remote/enterprise_service.dart';

import '../base/status_model.dart';
import '../services/local/auth_storage_service.dart';
import 'dart:io';

class EnterpriseRepo {
  static Future<Status> search(String searchTxt) async {
    final response = await EnterpriseService.search(searchTxt);
    if (response.statusCode == 200) {
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        return Status(
          isSuccess: true, 
          data: responseData.map<EnterpriseModel>( (value) =>
              EnterpriseModel.fromJson(value)
            ).toList());
      } else  {
        return Status(isSuccess: false);
      } 
  }

  static Future<Status> getInfo(String id) async {
    final response = await EnterpriseService.getInfo(id);
    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      return Status(isSuccess: true, data: EnterpriseModel.fromJson(responseData));
    } else {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } 
  }

  static Future<Status> deleteLogo(String id) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await EnterpriseService.deleteLogo(token, id);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        } else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> changeLogo(String id, File file) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await EnterpriseService.changeLogo(token, id, file);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        } else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> updateInfo(String id, Map<String, dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await EnterpriseService.updateInfo(token, id, data);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        }
        else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }
}