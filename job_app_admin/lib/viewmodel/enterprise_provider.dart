
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/repositories/enterprise_repository.dart';

import '../data/base/status_model.dart';
import '../data/model/enterprise_model.dart';

class EnterpriseProvider with ChangeNotifier {
  List<EnterpriseModel> searchList = [];

  void reset(String id) {
    if (id == '') {
      searchList = [];
    }
    notifyListeners();
  }

  Future<Status> search(String? searchTxt) async {
    searchTxt = searchTxt ?? '';
    Status status = await EnterpriseRepository.search(searchTxt);
    if (status.isSuccess) {
      searchList = status.data;
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> create(Map<String, dynamic> data) async {
    Status status = await EnterpriseRepository.create(data);
    if (status.isSuccess) {
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false, failMsg: status.failMsg);
    }
  }

  Future<Status> update(String enterpriseId, Map<String, dynamic> data) async {
    Status status = await EnterpriseRepository.update(enterpriseId, data);
    if (status.isSuccess) {
      for (var model in searchList) {
        if (model.id == enterpriseId) {
          model.taxCode = data['tax_code'] ?? model.taxCode;
          model.name = data['name'] ?? model.name;
        }
      }
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false, failMsg: status.failMsg);
    }
  }
}