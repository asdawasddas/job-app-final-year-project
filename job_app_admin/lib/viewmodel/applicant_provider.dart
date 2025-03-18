

import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/applicant_model.dart';
import 'package:job_app_admin/data/repositories/applicant_repository.dart';

import '../data/base/status_model.dart';

class ApplicantProvider with ChangeNotifier{
  List<ApplicantModel> applicantList = [];

  void create() {
    bool a = true;
    applicantList = List<ApplicantModel>.generate(20, (int index) {
      a = !a;
      return ApplicantModel.fromJson({
        'full_name': 'Nguyen Van Quang Huy $index',
        'email' : 'hieu1516963@gmail.com',
        'phone_number': '094825678',
        'is_blocked' : a
      });
    });
  }

  void reset(String id) {
    if (id == '') {
      applicantList = [];
      notifyListeners();
    }
  }

  Future<Status> search(String? searchTxt) async {
    searchTxt = searchTxt ?? '';
    Status status = await ApplicantRepository.hirers(searchTxt);
    if (status.isSuccess) {
      applicantList = status.data;
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> update(String applicantId, Map<String, dynamic> data) async {
    Status status = await ApplicantRepository.update(applicantId, data);
    if (status.isSuccess) {
      for (var model in applicantList) {
        if (model.id == applicantId) {
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