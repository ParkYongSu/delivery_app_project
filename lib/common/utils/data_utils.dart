import 'package:delivery_app_project/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) => "$domain/$value";

  static List<String> pathToUrlList(List imgUrls) {
    return imgUrls.map((e) => pathToUrl(e)).toList();
  }
}