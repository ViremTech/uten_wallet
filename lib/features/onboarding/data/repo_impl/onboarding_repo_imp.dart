import '../../domain/repository/onboarding_repo.dart';
import '../data_source/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<void> setLastScreen() async {
    await localDataSource.setLastScreen();
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    return await localDataSource.checkIsLastScreen();
  }
}
