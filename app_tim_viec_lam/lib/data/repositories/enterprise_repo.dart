
import 'dart:convert';

import '../base/status_model.dart';
import '../model/enterprise_model.dart';
import '../services/local/auth_storage_service.dart';
import '../services/remote/enterprise_service.dart';

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

  static Future<Status> favEnterprise(String applicantId) async {
    final String? token = await AuthStorageService.getToken();

    if (token == null) {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    } 
    final response = await EnterpriseService.favEnterprises(applicantId, token);
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
}