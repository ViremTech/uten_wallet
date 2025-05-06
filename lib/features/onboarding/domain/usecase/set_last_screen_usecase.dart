import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/onboarding_repo.dart';

class SetLastScreenUseCase extends Usecase<void, NoParams> {
  final OnboardingRepository repository;

  SetLastScreenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await repository.setLastScreen();
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
