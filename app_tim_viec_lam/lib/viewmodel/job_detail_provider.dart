
import 'package:app_tim_viec_lam/data/model/job_model.dart';
import 'package:app_tim_viec_lam/data/repositories/application_repo.dart';
import 'package:app_tim_viec_lam/data/repositories/job_repo.dart';
import 'package:flutter/material.dart';

import '../data/base/status_model.dart';
import '../data/model/application_model.dart';

class JobDetailProvider extends ChangeNotifier {
  String jobId = '';
  Job model = Job.fromJson({});
  Application application = Application.fromJson({});

  void setID(String id) {
    jobId = id;
  }

  Future<Status> getInfo() async {
    final Status status = await JobRepo.getInfo(jobId);
      if (status.isSuccess) {
        model = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> getUserApplication() async {
    final Status status = await ApplicationRepo.jobApplication(jobId);
      if (status.isSuccess) {
        application = status.data;
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }
}