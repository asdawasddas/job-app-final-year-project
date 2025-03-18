import 'dart:convert';

import 'package:app_tuyen_dung/data/models/job_model.dart';
import 'package:app_tuyen_dung/data/services/remote/jobs_service.dart';

import '../base/status_model.dart';
import '../services/local/auth_storage_service.dart';

class JobsRepo {
  static Future<Status> hirerJobs(String hirerId, int sort) async {
        final response = await JobsService.hirerJobs(hirerId, sort);
        if (response.statusCode == 200) {
          final responseData = json.decode(utf8.decode(response.bodyBytes));
          return Status(
            isSuccess: true, 
            data: responseData.map<Job>( (value) =>
              Job.fromJson(value)
            ).toList());
        } else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }

  static Future<Status> create(Map<String, dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await JobsService.create(token, data);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        }
        else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> update(String jobId, Map<String, dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await JobsService.update(token, jobId, data);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        }
        else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }

  static Future<Status> close(String jobId) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } else {
        final response = await JobsService.close(token, jobId);
        if (response.statusCode == 200) {
          return Status(isSuccess: true);
        }
        else {
          return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
        } 
    }
  }
}