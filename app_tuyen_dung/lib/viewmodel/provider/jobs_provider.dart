import 'package:app_tuyen_dung/data/models/job_model.dart';
import 'package:app_tuyen_dung/data/repositories/jobs_repo.dart';
import 'package:flutter/material.dart';

import '../../data/base/status_model.dart';

class JobsProvider with ChangeNotifier {
  String hirerId = '';
  List<Job> modelList = [];

  setUserId(String id) {
    hirerId = id;
    if(id == '') {
      reset();
    }
  }

  reset() {
    modelList = [];
  }

  Future<Status> getJobs(int sort) async{
    final Status status = await JobsRepo.hirerJobs(hirerId, sort);
      if (status.isSuccess) {
        modelList = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> closeJob(String jobId) async{
    final Status status = await JobsRepo.close(jobId);
      if (status.isSuccess) {
        for (var model in modelList) {
          if (model.id == jobId) {
            model.isClosed = true;
          }
        }
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> updateJob(String jobId, Map<String, dynamic> data) async{
    final Status status = await JobsRepo.update(jobId, data);
      if (status.isSuccess) {
        for (var model in modelList) {
          if (model.id == jobId) {
            model.update(data);
          }
        }
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
      }
  }

  Future<Status> createJob(Map<String, dynamic> data) async{
    final Status status = await JobsRepo.create(data);
      if (status.isSuccess) {
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
      }
  }
}