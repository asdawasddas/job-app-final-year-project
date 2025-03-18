
import 'package:flutter/material.dart';

import '../../data/base/status_model.dart';
import '../../data/model/enterprise_model.dart';
import '../../data/repositories/enterprise_repo.dart';

class EnterpriseProvider with ChangeNotifier {
  EnterpriseModel model = EnterpriseModel.fromJson({});
  List<EnterpriseModel> searchList = [];

  Future<Status> search(String? searchTxt) async {
    searchTxt = searchTxt ?? '';
    Status status = await EnterpriseRepo.search(searchTxt);
    if (status.isSuccess) {
      searchList = status.data;
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }
}