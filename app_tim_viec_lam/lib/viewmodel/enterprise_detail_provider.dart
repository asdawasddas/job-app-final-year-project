
import 'package:app_tim_viec_lam/data/model/enterprise_model.dart';
import 'package:app_tim_viec_lam/data/model/job_model.dart';
import 'package:app_tim_viec_lam/data/repositories/job_repo.dart';
import 'package:flutter/material.dart';

import '../data/base/status_model.dart';
import '../data/repositories/enterprise_repo.dart';

class EnterpriseDetailProvider extends ChangeNotifier {
  String enterpriseId = '';
  EnterpriseModel model = EnterpriseModel.fromJson({});
  List<Job> enterpriseJobs = [];

  void setID(id) {
    enterpriseId = id;
  }

  Future<Status> getEnterpriseDetail() async {
    final Status status = await EnterpriseRepo.getInfo(enterpriseId);
      if (status.isSuccess) {
        model = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> getEnterpriseJobs() async {
    final Status status = await JobRepo.enterpriseJobs(enterpriseId);
      if (status.isSuccess) {
        enterpriseJobs = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }
}