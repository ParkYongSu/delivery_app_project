import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/provider/pagination_provider.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:delivery_app_project/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPaginationModel) return null;

  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  return RestaurantStateNotifier(repository: repository);
});

class RestaurantStateNotifier
    extends PaginationStateNotifier<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  Future<void> getDetail({
    required String id,
  }) async {
    if (state is! CursorPaginationModel) {
      await paginate();
    }

    if (state is! CursorPaginationModel) return;

    final pState = state as CursorPaginationModel;

    final response = await repository.getRestaurantDetailModel(id: id);

    if (pState.data.where((element) => element.id == id).isEmpty) {
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          response,
        ]
      );
    }
    else {
      state = pState.copyWith(
        meta: pState.meta,
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? response : e)
            .toList(),
      );
    }
  }
}
