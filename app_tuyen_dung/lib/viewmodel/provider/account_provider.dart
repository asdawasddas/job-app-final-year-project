import 'dart:io';

import 'package:app_tuyen_dung/data/base/status_model.dart';
import 'package:app_tuyen_dung/data/models/hirer_account_model.dart';
import 'package:app_tuyen_dung/data/models/statistic_model.dart';
import 'package:app_tuyen_dung/data/repositories/account_repo.dart';
import 'package:flutter/material.dart';

class AccountProvider with ChangeNotifier {

  String hirerId = '';

  HirerAccountModel model = HirerAccountModel.fromJson({});

  Statistic statistic = Statistic.fromJson({});

  setUserId(String id) {
    hirerId = id;
    if (id == '') {
      reset();
    }
  }

  reset() {
    model = HirerAccountModel.fromJson({});
    statistic = Statistic.fromJson({});
    notifyListeners();
  }

  Future<Status> getStatistic() async{
    final Status status = await AccountRepo.statistic(hirerId);
      if (status.isSuccess) {
        statistic = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }


  Future<Status> getAccountInfo() async{
    final Status status = await AccountRepo.getAccountInfo(hirerId);
      if (status.isSuccess) {
        model = status.data;
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> changeAvatar(File file) async {
    final Status status = await AccountRepo.changeAvatar(hirerId, file);
    if (status.isSuccess) {
        model.avatarUrl = '';
        notifyListeners();
        getAccountInfo();
        // notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> changeAvatarUrl(Map<String, dynamic> data) async{
    final Status status = await AccountRepo.changeAvatarUrl(hirerId, data);
    if (status.isSuccess) {
      getAccountInfo();
      notifyListeners();
      return Status(isSuccess: true);
    } else {
      return Status(isSuccess: false);
    }
  }

  Future<Status> deleteAvatar() async{
    final Status status = await AccountRepo.deleteAvatar(hirerId);
      if (status.isSuccess) {
        getAccountInfo();
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false);
      }
  }

  Future<Status> changePassword(Map<String, dynamic> data) async{
    final Status status = await AccountRepo.changePassword(hirerId, data);
      if (status.isSuccess) {
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
      }
  }

  Future<Status> updateInfo(Map<String, dynamic> data) async{
    final Status status = await AccountRepo.updateInfo(hirerId, data);
      if (status.isSuccess) {
        getAccountInfo();
        notifyListeners();
        return Status(isSuccess: true);
      } else {
        return Status(isSuccess: false, failMsg: status.failMsg);
      }
  }
}