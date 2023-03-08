import 'package:delivery_app_project/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("[REQ]");

    if (options.headers["accessToken"] == "true") {
      final accessToken = await storage.read(key: accessTokenKey);

      options.headers.remove("accessToken");
      options.headers.addAll({
        "Authorization": "Bearer $accessToken",
      });
    }

    if (options.headers["refreshToken"] == "true") {
      final accessToken = await storage.read(key: accessTokenKey);

      options.headers.remove("refreshToken");
      options.headers.addAll({
        "Authorization": "Bearer $accessToken",
      });
    }

    super.onRequest(options, handler);
  }
}
