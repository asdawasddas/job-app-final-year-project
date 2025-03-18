import 'dart:io';

import 'package:app_tim_viec_lam/data/model/enterprise_model.dart';
import 'package:app_tim_viec_lam/data/repositories/application_repo.dart';
import 'package:app_tim_viec_lam/data/repositories/enterprise_repo.dart';
import 'package:app_tim_viec_lam/data/repositories/job_repo.dart';
import 'package:flutter/material.dart';

import '../../data/base/status_model.dart';
import '../../data/model/applicant_model.dart';
import '../../data/model/application_model.dart';
import '../../data/model/job_model.dart';
import '../../data/repositories/account_repo.dart';

class AccountProvider with ChangeNotifier {

  String applicantId = '';

  Applicant model = Applicant.fromJson({});

  List<Application> appliedJobs = [];
  List<Job> favJobs = [];
  List<EnterpriseModel> favEnterprise = [];
  List<Job> favEnterpriseJobs = [];

  setUserId(String id) {
    applicantId = id;
    if (id == '') {
      reset();
    }
  }

  reset() {
    model = Applicant.fromJson({});
    notifyListeners();
  }

  Future<Status> getAppliedJobs() async{
    if (applicantId == '') {
      return Status(isSuccess: true);
    }

    final Status status = await ApplicationRepo.applications(applicantId);
      if (status.isSuccess) {
        appliedJobs = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> getFavJobs() async{
    if (applicantId == '') {
      return Status(isSuccess: true);
    }

    final Status status = await JobRepo.favJobs(applicantId);
      if (status.isSuccess) {
        favJobs = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> getFavEnterPriseJob() async{
    if (applicantId == '') {
      return Status(isSuccess: true);
    }

    final Status status = await JobRepo.favEnterpriseJobs(applicantId);
      if (status.isSuccess) {
        favEnterpriseJobs = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> getFavEnterprises() async{
    if (applicantId == '') {
      return Status(isSuccess: true);
    }

    final Status status = await EnterpriseRepo.favEnterprise(applicantId);
      if (status.isSuccess) {
        favEnterprise = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> getAccountInfo() async{
    if (applicantId == '') {
      return Status(isSuccess: true);
    }

    final Status status = await AccountRepo.getAccountInfo(applicantId);
      if (status.isSuccess) {
        model = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> changeAvatar(File file) async {
    final Status status = await AccountRepo.changeAvatar(applicantId, file);
    if (status.isSuccess) {
        getAccountInfo();
        
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> changeAvatarUrl(Map<String, dynamic> data) async{
    final Status status = await AccountRepo.changeAvatarUrl(applicantId, data);
    if (status.isSuccess) {
      getAccountInfo();
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> deleteAvatar() async{
    final Status status = await AccountRepo.deleteAvatar(applicantId);
      if (status.isSuccess) {
        getAccountInfo();
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> changePassword(Map<String, dynamic> data) async{
    final Status status = await AccountRepo.changePassword(applicantId, data);
      if (status.isSuccess) {
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
      }
  }

  Future<Status> updateInfo(Map<String, dynamic> data) async{
    final Status status = await AccountRepo.updateInfo(applicantId, data);
    if (status.isSuccess) {
        getAccountInfo();
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
    }
  }

  Future<Status> apply(String jobId, File file) async {
    final Status status = await AccountRepo.apply(jobId, file);
    if (status.isSuccess) {
        getAccountInfo();
        model.appliedJobs.add(jobId);
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
    }
  }

  bool isFavJob(String jobId) {
    return model.favJobs.contains(jobId);
  } 

  Future<Status> toggleAddJob(String jobId) async {
    if (isFavJob(jobId)) {
      model.favJobs.removeWhere((id) => id == jobId);
    } else {
      model.favJobs.add(jobId);
    }
    final Status status = await AccountRepo.updateInfo(applicantId, {
      'fav_jobs' : model.favJobs
    });
    if (status.isSuccess) {
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
    }
  }

  Future<Status> toggleAddEnterPrise(String enterpriseId) async {
    if (isFavEnterprise(enterpriseId)) {
      model.favEnterprise.removeWhere((id) => id == enterpriseId);
    } else {
      model.favEnterprise.add(enterpriseId);
    }
    final Status status = await AccountRepo.updateInfo(applicantId, {
      'fav_enterprises' : model.favEnterprise
    });
    if (status.isSuccess) {
        getFavEnterPriseJob();
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
    }
  }

  void addFavJob(String jobId) {
    model.favJobs.add(jobId);
    notifyListeners();
  }

  void removeFavJob(String jobId) {
    model.favJobs.removeWhere((id) => id == jobId);
    notifyListeners();
  }

  bool isFavEnterprise(String enterpriseId) {
    return model.favEnterprise.contains(enterpriseId);
  } 

  bool isApplied(String jobId) {
    return model.appliedJobs.contains(jobId);
  }
}