import 'package:app_tim_viec_lam/data/model/job_model.dart';
import 'package:app_tim_viec_lam/data/model/job_search_model.dart';
import 'package:app_tim_viec_lam/data/repositories/job_repo.dart';
import 'package:flutter/material.dart';

import '../../data/base/status_model.dart';

class JobProvider with ChangeNotifier {
  List<Job> searchList = [];

  Future<Status> search(JobSearchModel jobSearchModel) async {
    Status status = await JobRepo.search(jobSearchModel);
    if (status.isSuccess) {
      searchList = status.data;
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  reset() {
    searchList = [];
  }
}