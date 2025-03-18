
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/base/status_model.dart';
import 'package:job_app_admin/data/model/admin_model.dart';
import 'package:job_app_admin/data/repositories/admin_repository.dart';
import 'package:job_app_admin/data/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  String adminId = '';
  Admin model = Admin.fromJson({});

  void setUserId(String id) {
    adminId = id;
    notifyListeners();
  }

  void logOut() {
    AuthRepository.logOut();
    adminId = '';
    model = Admin.fromJson({});
    notifyListeners();
  }

  Future<Status> getInfo() async {
    Status status = await AuthRepository.getInfo(adminId);
    if (status.isSuccess) {
      model = status.data;
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> login(Map<String, dynamic> data) async {
    Status status = await AuthRepository.login(data);
    if (status.isSuccess) {
      setUserId(status.data);
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false, failMsg: status.failMsg);
    }
  }

  Future<Status> authenticate() async {
    Status status = await AuthRepository.authenticate();
    if (status.isSuccess) {
      setUserId(status.data);
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> changePassword(Map<String, dynamic> data) async {
    Status status = await AdminRepository.changePassword(adminId, data);
    if (status.isSuccess) {
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> update(Map<String, dynamic> data) async {
    Status status = await AdminRepository.update(adminId, data);
    if (status.isSuccess) {
      model.fullName = data['full_name'] ?? model.fullName;
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }
}