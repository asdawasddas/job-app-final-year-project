import 'dart:convert';
import 'package:job_app_admin/data/model/enterprise_model.dart';

import '../base/api_routes.dart';
import '../base/status_model.dart';
import '../sercure_storage_srv.dart';
import 'package:http/http.dart' as http;

class EnterpriseRepository {
  static Future<Status> search(String searchTxt) async {
      String url = ApiRoutes.enterprises + '?search=$searchTxt';

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

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

  static Future<Status> detail(String enterpriseId) async {
      final response = await http.get(
        Uri.parse(ApiRoutes.enterpriseInfo(enterpriseId)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        return Status(
          isSuccess: true, 
          data: EnterpriseModel.fromJson(responseData)
          );
      } else  {
        return Status(isSuccess: false);
      } 
  }

  static Future<Status> create(data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, );
    } else {
      final response = await http.post(
        Uri.parse(ApiRoutes.enterprises),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return Status(isSuccess: true,);
      } else if (response.statusCode == 409) {
        return Status(isSuccess: false, failMsg: 'Tên hoặc mã số thuế này đã được đăng ký');
      } else {
        return Status(isSuccess: false);
      }
    }
  }

  static Future<Status> update(enterpriseId, data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, );
    } else {
      final response = await http.put(
        Uri.parse(ApiRoutes.enterpriseInfo(enterpriseId)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return Status(isSuccess: true,);
      } else if (response.statusCode == 409) {
        return Status(isSuccess: false, failMsg: 'Tên hoặc mã số thuế này đã được đăng ký');
      } else {
        return Status(isSuccess: false);
      }
    }
  }
}