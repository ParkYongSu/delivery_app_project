import 'dart:convert';

import 'package:delivery_app_project/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) => "$domain/$value";

  static List<String> pathToUrlList(List imgUrls) {
    return imgUrls.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    var codec = utf8.fuse(base64);
    var stringToBase64 = codec.encode(plain);

    return stringToBase64;
  }
}