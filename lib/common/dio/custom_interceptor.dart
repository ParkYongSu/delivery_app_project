import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/secure_storage/secure_storage_provider.dart';
import 'package:delivery_app_project/user/provider/auth_provider.dart';
import 'package:delivery_app_project/user/provider/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("[REQ] ${options.uri}");

    if (options.headers["accessToken"] == "true") {
      final accessToken = await storage.read(key: accessTokenKey);

      options.headers.remove("accessToken");
      options.headers.addAll({
        "Authorization": "Bearer $accessToken",
      });
    }

    if (options.headers["refreshToken"] == "true") {
      final refreshToken = await storage.read(key: refreshTokenKey);

      options.headers.remove("refreshToken");
      options.headers.addAll({
        "Authorization": "Bearer $refreshToken",
      });
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print(
        "[ERR] [${err.error}] ${err.requestOptions.uri} ${err.response?.statusCode} ${err.requestOptions.headers}");

    var isTokenExpiration = err.response?.statusCode == 401;

    if (isTokenExpiration) {
      var isRefreshTokenPath = err.requestOptions.path == "/auth/token";

      if (isRefreshTokenPath) {
        return handler.reject(err);
      }

      final refreshToken = await storage.read(key: refreshTokenKey);

      try {
        final dio = Dio();
        final response = await dio.post(
          "$domain/auth/token",
          options: Options(headers: {
            "Authorization": "Bearer $refreshToken",
          }),
        );

        final accessToken = response.data["accessToken"];

        await storage.write(
          key: accessTokenKey,
          value: accessToken,
        );

        var options = err.requestOptions;

        options.headers.addAll({"Authorization": "Bearer $accessToken"});

        final fetchResponse = await dio.fetch(options);

        return handler.resolve(fetchResponse);
      } catch (e) {
        ref.read(authProvider.notifier).logout();
        return handler.reject(err);
      }
    }

    return handler.reject(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("[RES] ${response.requestOptions.uri}");
    super.onResponse(response, handler);
  }
}
