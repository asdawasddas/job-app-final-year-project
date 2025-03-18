import 'dart:io';

import 'package:app_tuyen_dung/data/models/enterprise_model.dart';
import 'package:app_tuyen_dung/data/repositories/enterprise_repo.dart';
import 'package:flutter/material.dart';

import '../../data/base/status_model.dart';

class EnterpriseProvider with ChangeNotifier {
  String enterpriseId = '';
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


  setEnterpriseId(String id) {
    enterpriseId = id;
    if(id == '') {
      reset();
    }
    getInfo();
    
  }

  reset() {
    model = EnterpriseModel.fromJson({});
  }

  Future<Status> getInfo() async{
    if (enterpriseId == '') {
        return Status(isSuccess: true);
      }
    final Status status = await EnterpriseRepo.getInfo(enterpriseId);
      if (status.isSuccess) {
        model = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> changeLogo(File file) async {
    if (enterpriseId == '') {
        return Status(isSuccess: true);
      }
    final Status status = await EnterpriseRepo.changeLogo(enterpriseId, file);
    if (status.isSuccess) {
        getInfo();
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> changeLogoUrl(Map<String, dynamic> data) async{
    if (enterpriseId == '') {
        return Status(isSuccess: true);
      }
    final Status status = await EnterpriseRepo.updateInfo(enterpriseId, data);
    if (status.isSuccess) {
      getInfo();
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> deleteLogo() async{
    if (enterpriseId == '') {
        return Status(isSuccess: true);
      }
    final Status status = await EnterpriseRepo.deleteLogo(enterpriseId);
      if (status.isSuccess) {
        getInfo();
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> updateInfo(Map<String, dynamic> data) async{
    if (enterpriseId == '') {
        return Status(isSuccess: true);
      }
    final Status status = await EnterpriseRepo.updateInfo(enterpriseId, data);
      if (status.isSuccess) {
        getInfo();
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
      }
  }
}