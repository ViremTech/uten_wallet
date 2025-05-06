import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/authentication/domain/repository/auth_repo.dart';

class DeletePasswordUsecase implements Usecase<bool, NoParams> {
  final AuthRepo authRepo;

  DeletePasswordUsecase({required this.authRepo});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepo.deletePassword();
  }
}
