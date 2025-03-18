
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/admin_model.dart';
import 'package:job_app_admin/data/repositories/admin_repository.dart';

import '../data/base/status_model.dart';

class AdminProvider with ChangeNotifier {
  List<Admin> adminList = [];

  void reset(String id) {
    if (id == '') {
      adminList = [];
    }
    notifyListeners();
  }

  Future<Status> getList() async {
    Status status = await AdminRepository.admins();
    if (status.isSuccess) {
      adminList = status.data;
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> create(Map<String, dynamic> data) async {
    Status status = await AdminRepository.create(data);
    if (status.isSuccess) {
      await getList();
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false, failMsg: status.failMsg);
    }
  }

  Future<Status> update(String adminId, Map<String, dynamic> data) async {
    Status status = await AdminRepository.update(adminId, data);
    if (status.isSuccess) {
      for (var model in adminList) {
        if (model.id == adminId) {
          model.fullName = data['full_name'] ?? model.fullName;
        }
      }
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> delete(String adminId) async {
    Status status = await AdminRepository.delete(adminId);
    if (status.isSuccess) {
      await getList();
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> changePassword(String adminId, Map<String, dynamic> data) async {
    Status status = await AdminRepository.changePassword(adminId, data);
    if (status.isSuccess) {
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }
}