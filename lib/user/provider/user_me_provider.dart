import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/secure_storage/secure_storage_provider.dart';
import 'package:delivery_app_project/user/model/user_model.dart';
import 'package:delivery_app_project/user/repository/auth_repository.dart';
import 'package:delivery_app_project/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    authRepository: authRepository,
    userMeRepository: userMeRepository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository userMeRepository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.userMeRepository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final accessToken = await storage.read(key: accessTokenKey);
    final refreshToken = await storage.read(key: refreshTokenKey);

    if (accessToken == null || refreshToken == null) {
      state = null;
      return;
    }

    final response = await userMeRepository.getMe();

    state = response;
  }

  Future<UserModelBase> login({
    required String userName,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final loginResponse = await authRepository.login(
        userName: userName,
        password: password,
      );

      await Future.wait([
        storage.write(
          key: refreshTokenKey,
          value: loginResponse.refreshToken,
        ),
        storage.write(
          key: accessTokenKey,
          value: loginResponse.accessToken,
        ),
      ]);

      final userResponse = await userMeRepository.getMe();

      state = userResponse;

      return userResponse;
    } catch (e) {
      state = UserModelError(message: "Login Error");

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait(
      [
        storage.delete(key: refreshTokenKey),
        storage.delete(key: accessTokenKey),
      ],
    );
  }
}
