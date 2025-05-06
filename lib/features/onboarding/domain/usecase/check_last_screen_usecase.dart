import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/onboarding_repo.dart';

class CheckLastScreenUseCase extends Usecase<bool, NoParams> {
  final OnboardingRepository repository;

  CheckLastScreenUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final result = await repository.hasSeenOnboarding();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
