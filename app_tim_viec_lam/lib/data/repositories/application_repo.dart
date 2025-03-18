
import 'dart:convert';

import 'package:app_tim_viec_lam/data/model/application_model.dart';
import 'package:app_tim_viec_lam/data/services/remote/application_service.dart';

import '../base/status_model.dart';
import '../services/local/auth_storage_service.dart';

class ApplicationRepo {

  static Future<Status> jobApplication(String jobId) async {
    final String? token = await AuthStorageService.getToken();

    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } 
    final response = await ApplicationService.jobApplication(jobId, token);
    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      return Status(isSuccess: true, data: Application.fromJson(responseData));
    } else {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } 
  }

  static Future<Status> applications(String applicantId) async {
    final String? token = await AuthStorageService.getToken();

    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } 
    final response = await ApplicationService.applicantApplications(applicantId, token);
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