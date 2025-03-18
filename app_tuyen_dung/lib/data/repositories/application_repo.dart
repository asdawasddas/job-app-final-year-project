import 'dart:convert';

import 'package:app_tuyen_dung/data/models/application_model.dart';
import 'package:app_tuyen_dung/data/services/remote/application_service.dart';

import '../base/status_model.dart';
import '../services/local/auth_storage_service.dart';

class ApplicationRepo {
  static Future<Status> jobApplications(String jobId, int sort) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
      final response = await ApplicationService.getJobApplications(token ,jobId , sort);
      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        return Status(
          isSuccess: true, 
          data: responseData.map<Application>( (value) =>
            Application.fromJson(value)
          ).toList());
      } else {
        return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
      } 
    }
  }

  static Future<Status> update(String applicationId, Map<String, dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await ApplicationService.update(token, applicationId, data);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        }
        else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }
}