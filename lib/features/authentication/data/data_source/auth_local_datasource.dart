import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uten_wallet/core/error/exception.dart';

abstract class AuthLocalDatasource {
  Future<void> savePassword(String password);
  Future<bool> verifyPassword(String password);
  Future<bool> deletePassword();
  Future<bool> persistLoginState(String isLoadedIn);
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage storage;
  AuthLocalDatasourceImpl({required this.storage});
  final _key = 'wallet_password';

  @override
  Future<bool> deletePassword() async {
    await storage.delete(key: _key);
    final deletePassword = (await storage.read(key: _key)) == null;
    if (deletePassword) {
      return deletePassword;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> savePassword(String password) async {
    final hashed = sha256.convert(utf8.encode(password)).toString();
    await storage.write(key: _key, value: hashed);
  }

  @override
  Future<bool> verifyPassword(String password) async {
    final storedHash = await storage.read(key: _key);
    final inputHash = sha256
        .convert(
          utf8.encode(password),
        )
        .toString();
    if (storedHash == inputHash) {
      return true;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> persistLoginState(String isLoadedIn) async {
    await storage.write(
      key: 'isLoggedIn',
      value: isLoadedIn,
    );
    final isLoggedIn = await storage.read(key: 'isLoggedIn');
    if (isLoggedIn == 'true') {
      return true;
    } else {
      throw CacheException();
    }
  }
}
