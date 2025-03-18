import 'dart:convert';

import '../base/status_model.dart';
import '../services/remote/auth_service.dart';
import '../services/local/auth_storage_service.dart';

class AuthRepo {
  static logOut() async{
    await AuthStorageService.logOut();
  }

  static Future<Status> authenticate() async {
    final String? token = await AuthStorageService.getToken();
    if (token == null) {
      return Status(isSuccess: false, );
    } else {
        final response = await AuthService.authenticate(token);
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          return Status(isSuccess: true, data: responseData['id']);
        } else if (response.statusCode == 401) {
          return Status(isSuccess: false);
        } else {
          return Status(isSuccess: false);
        } 
    }
  }

  static Future<Status> login(data) async {
    late Status status;
    final response = await AuthService.login(data);
    
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      await AuthStorageService.logIn(token: responseData['token']);
      status = Status(isSuccess: true, data: responseData['id']);
    } else if (response.statusCode == 401) {
      status = Status(isSuccess: false, failMsg: 'Mật khẩu hoặc email sai');
    } else {
      status = Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    }
    return status;
  }

  static Future<Status> signUp(data) async {
    final response = await AuthService.signUp(data);

    if (response.statusCode == 200) {
      return Status(isSuccess: true);

    } else if (response.statusCode == 409) {
      return Status(isSuccess: false, failMsg: 'Email đã được sử dụng, vui lòng chọn email khác');

    } else {
      return Status(isSuccess: false, failMsg: 'Đã có lỗi xảy ra');
    }
  }
  
}