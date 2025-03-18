
import 'dart:convert';

import 'package:app_tim_viec_lam/data/model/job_model.dart';
import 'package:app_tim_viec_lam/data/model/job_search_model.dart';
import 'package:app_tim_viec_lam/data/services/remote/job_service.dart';

import '../base/status_model.dart';
import '../services/local/auth_storage_service.dart';

class JobRepo {
  static Future<Status> search(JobSearchModel model) async {
    final response = await JobService.jobs(model.seartchTxt);
    if (response.statusCode == 200) {
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        return Status(
          isSuccess: true, 
          data: responseData.map<Job>( (value) =>
              Job.fromJson(value)
            ).toList());
      } else  {
        return Status(isSuccess: false);
      } 
  }

  static Future<Status> getInfo(String id) async {
    final response = await JobService.getInfo(id);
    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      return Status(isSuccess: true, data: Job.fromJson(responseData));
    } else {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } 
  }

  static Future<Status> favJobs(String applicantId) async {
    final String? token = await AuthStorageService.getToken();

    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } 
    final response = await JobService.favJobs(applicantId, token);
    if (response.statusCode == 200) {
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        return Status(
          isSuccess: true, 
          data: responseData.map<Job>( (value) =>
              Job.fromJson(value)
            ).toList());
      } else  {
        return Status(isSuccess: false);
      } 
  }

  static Future<Status> favEnterpriseJobs(String applicantId) async {
    final String? token = await AuthStorageService.getToken();

    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } 
    final response = await JobService.favEnterpriseJobs(applicantId, token);
    if (response.statusCode == 200) {
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        return Status(
          isSuccess: true, 
          data: responseData.map<Job>( (value) =>
              Job.fromJson(value)
            ).toList());
      } else  {
        return Status(isSuccess: false);
      } 
  }

  static Future<Status> enterpriseJobs(String enterpriseId) async {
    final response = await JobService.enterpriseJobs(enterpriseId);
    if (response.statusCode == 200) {
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        return Status(
          isSuccess: true, 
          data: responseData.map<Job>( (value) =>
              Job.fromJson(value)
            ).toList());
      } else  {
        return Status(isSuccess: false);
      } 
  }
}