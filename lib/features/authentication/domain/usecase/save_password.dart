import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';

import '../repository/auth_repo.dart';

class SavePasswordUsecase implements Usecase<Unit, String> {
  final AuthRepo authRepo;

  SavePasswordUsecase({required this.authRepo});

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await authRepo.savePassword(params);
  }
}
