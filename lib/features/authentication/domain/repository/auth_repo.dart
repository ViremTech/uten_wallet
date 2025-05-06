import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';

abstract class AuthRepo {
  Future<Either<Failure, Unit>> savePassword(String password);
  Future<Either<Failure, bool>> validatePassword(String password);
  Future<Either<Failure, bool>> deletePassword();
  Future<Either<Failure, bool>> persistLoginState(String isLoadedIn);
}
