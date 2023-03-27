import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/dio/custom_interceptor.dart';
import 'package:delivery_app_project/common/model/login_response.dart';
import 'package:delivery_app_project/common/model/token_response.dart';
import 'package:delivery_app_project/common/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(
    dio: dio,
    baseUrl: "$domain/auth",
  );
});

class AuthRepository {
  final Dio dio;
  final String baseUrl;

  AuthRepository({
    required this.dio,
    required this.baseUrl,
  });

  Future<LoginResponse> login({
    required String userName,
    required String password,
  }) async {
    final token = DataUtils.plainToBase64("$userName:$password");

    final response = await dio.post(
      "$baseUrl/login",
      options: Options(
        headers: {
          "authorization": "Basic $token",
        },
      ),
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<TokenResponse> token() async {
    final response = await dio.get("$baseUrl/token",
        options: Options(headers: {"refreshToken": "true"}));

    return TokenResponse.fromJson(response.data);
  }
}
