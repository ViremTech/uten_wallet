import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/exception.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/features/authentication/data/data_source/auth_local_datasource.dart';
import 'package:uten_wallet/features/authentication/domain/repository/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthLocalDatasource localDatasource;

  AuthRepoImpl({required this.localDatasource});

  @override
  Future<Either<Failure, bool>> deletePassword() async {
    try {
      final deletePassword = await localDatasource.deletePassword();
      return right(deletePassword);
    } on CacheException {
      return left(
        CacheFailure('Unable to Delete Password'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> persistLoginState(String isLoadedIn) async {
    try {
      final persistLogin = await localDatasource.persistLoginState(isLoadedIn);
      return right(persistLogin);
    } on CacheException {
      return left(
        CacheFailure(
          'State not persist',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> savePassword(String password) async {
    try {
      await localDatasource.savePassword(password);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          'Unable to save password',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> validatePassword(String password) async {
    try {
      final validatePassword = await localDatasource.verifyPassword(password);
      return right(validatePassword);
    } on CacheException {
      return left(
        CacheFailure(
          'Unable to validate Password',
        ),
      );
    }
  }
}
