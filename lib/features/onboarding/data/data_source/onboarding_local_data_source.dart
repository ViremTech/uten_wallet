import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class OnboardingLocalDataSource {
  Future<void> setLastScreen();
  Future<bool> checkIsLastScreen();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final FlutterSecureStorage storage;

  OnboardingLocalDataSourceImpl({required this.storage});

  @override
  Future<bool> checkIsLastScreen() async {
    final storageCheck = await storage.read(key: 'hasSeenOnboarding');
    return storageCheck == 'true';
  }

  @override
  Future<void> setLastScreen() async {
    await storage.write(key: 'hasSeenOnboarding', value: 'true');
  }
}
