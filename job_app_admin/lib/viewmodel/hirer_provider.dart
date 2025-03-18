
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/enterprise_model.dart';
import 'package:job_app_admin/data/model/hirer_model.dart';
import 'package:job_app_admin/data/repositories/enterprise_repository.dart';
import 'package:job_app_admin/data/repositories/hirer_repository.dart';

import '../data/base/status_model.dart';

class HirerProvider with ChangeNotifier{
  List<HirerModel> hirerList = [];
  EnterpriseModel enterprise = EnterpriseModel.fromJson({});

  Future<Status> getEnterprise(String enterpriseId) async {
    Status status = await EnterpriseRepository.detail(enterpriseId);
    if (status.isSuccess) {
      enterprise = status.data;
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  void reset(String id) {
    if (id == '') {
      hirerList = [];
      notifyListeners();
    }
  }

  Future<Status> search(String? searchTxt) async {
    searchTxt = searchTxt ?? '';
    Status status = await HirerRepository.hirers(searchTxt);
    if (status.isSuccess) {
      hirerList = status.data;
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> update(String hirerId, Map<String, dynamic> data) async {
    Status status = await HirerRepository.update(hirerId, data);
    if (status.isSuccess) {
      for (var model in hirerList) {
        if (model.id == hirerId) {
          model.isConfirmed = data['is_confirmed'] ?? model.isConfirmed;
          model.isBlocked = data['is_blocked'] ?? model.isBlocked;
        }
      }
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }
}