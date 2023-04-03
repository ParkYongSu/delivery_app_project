import 'package:delivery_app_project/common/provider/pagination_provider.dart';
import 'package:flutter/cupertino.dart';

class PaginationUtils {
  static void paginate(
      {required ScrollController controller,
      required PaginationStateNotifier stateNotifier}) {
    if (controller.offset >= controller.position.maxScrollExtent) {
      stateNotifier.paginate(
        fetchMore: true,
      );
    }
  }
}
