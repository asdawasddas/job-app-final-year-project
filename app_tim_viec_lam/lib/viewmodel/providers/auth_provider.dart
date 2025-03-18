import 'package:flutter/material.dart';

import '../../data/base/status_model.dart';
import '../../data/repositories/auth_repo.dart';

class AuthProvider with ChangeNotifier {
  String applicantId = '';
  bool isLoading = false;

  void setUserId(String id) {
    applicantId = id;
    notifyListeners();
  }

  logOut() async {
    await AuthRepo.logOut();
    setUserId('');
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<Status> authenticate() async {
    // setLoading(true);
    isLoading = true;
    await Future.delayed(const Duration(seconds: 1));
    Status status = await AuthRepo.authenticate();
    if (status.isSuccess) {
      setUserId(status.data);
    }
    isLoading = false;
    // setLoading(false);
    notifyListeners();
    return status;
  }

  Future<Status> login(data, BuildContext context) async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    Status status = await AuthRepo.login(data);
    if (status.isSuccess) {
      setUserId(status.data);
    }
    setLoading(false);
    notifyListeners();
    return status;
  }

  Future<Status> signUp(data) async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    Status status = await AuthRepo.signUp(data);
    setLoading(false);
    return status;
  }
}