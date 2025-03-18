
import 'package:app_tuyen_dung/data/base/status_model.dart';
import 'package:app_tuyen_dung/data/repositories/auth_repo.dart';
import 'package:flutter/material.dart';


class AuthViewModel extends ChangeNotifier{

  bool isLoading = false;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<Status> authenticate() async {
    setLoading(true);
    Status status = await AuthRepo.authenticate();
    setLoading(false);
    return status;
  }

  Future<Status> login(data, BuildContext context) async {
    setLoading(true);
    // isLoading = true;
    await Future.delayed(const Duration(milliseconds: 500));
    Status status = await AuthRepo.login(data);
    // isLoading = false;
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
