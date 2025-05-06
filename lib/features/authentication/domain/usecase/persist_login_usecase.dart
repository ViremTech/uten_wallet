import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/authentication/domain/repository/auth_repo.dart';

class PersistLoginUsecase implements Usecase<bool, String> {
  final AuthRepo authRepo;

  PersistLoginUsecase({required this.authRepo});
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await authRepo.persistLoginState(params);
  }
}
