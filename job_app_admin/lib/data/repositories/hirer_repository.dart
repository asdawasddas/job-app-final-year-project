import 'dart:convert';
import 'package:job_app_admin/data/model/hirer_model.dart';

import '../base/api_routes.dart';
import '../base/status_model.dart';
import '../sercure_storage_srv.dart';
import 'package:http/http.dart' as http;

class HirerRepository {
  static Future<Status> hirers(String? searchTxt) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, );
    } else {
      String url = ApiRoutes.hirers + '?search=$searchTxt';
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        return Status(
          isSuccess: true, 
          data: responseData.map<HirerModel>( (value) =>
              HirerModel.fromJson(value)
            ).toList());
      } else  {
        return Status(isSuccess: false);
      } 
    }
  }

  static Future<Status> update(String hirerId, Map<String,dynamic> data) async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, );
    } else {
      final response = await http.put(
        Uri.parse(ApiRoutes.hirerInfo(hirerId)),
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