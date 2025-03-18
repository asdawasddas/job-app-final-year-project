import 'package:app_tuyen_dung/data/models/application_model.dart';
import 'package:app_tuyen_dung/data/models/job_model.dart';
import 'package:app_tuyen_dung/data/repositories/application_repo.dart';
import 'package:flutter/material.dart';

import '../../data/base/status_model.dart';

class ApplicationsProvider with ChangeNotifier {
  Job job = Job.fromJson({});
  List<Application> modelList = [];
  bool isLoading = false;

  setJob(Job model) {
    job = model;
    getApplications(0);
  }

  reset() {
    job = Job.fromJson({});
    modelList = [];
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<Status> getApplications(int sort) async{
    setLoading(true);
    final Status status = await ApplicationRepo.jobApplications(job.id, sort);
      if (status.isSuccess) {
        modelList = status.data;
        setLoading(false);
        return Status(isSuccess: true);
      } else {
        setLoading(true);
        return Status(isSuccess: false);
      }
  }

  Future<Status> update(String applicationId, Map<String, dynamic> data) async{
    final Status status = await ApplicationRepo.update(applicationId, data);
      if (status.isSuccess) {
        for (var model in modelList) {
          if (model.id == applicationId) {
            model.update(data);
          }
        }
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
      }
  }
}