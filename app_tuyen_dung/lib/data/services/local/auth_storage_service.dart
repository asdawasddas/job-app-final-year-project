import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorageService {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'token';

  static Future logIn({required String token}) async {
      await _storage.write(key: _keyToken, value: token);
  }

  static Future<String?> getToken() async =>
    await _storage.read(key: _keyToken);

  static Future logOut() async {
    await _storage.delete(key: _keyToken);
  }
}