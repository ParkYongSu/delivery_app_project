import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/model/pagination_params.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:delivery_app_project/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPaginationModel) return null;

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  return RestaurantStateNotifier(repository: repository);
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      if (state is CursorPaginationModel && !forceRefetch) {
        final pState = state as CursorPaginationModel;
        if (!pState.meta.hasMore) return;
      }

      final isLoading = state is CursorPaginationLoading;
      final isFetchMore = state is CursorPaginationFetchingMore;
      final isRefetching = state is CursorPaginationRefetching;

      if (fetchMore && (isLoading || isFetchMore || isRefetching)) return;

      var params = PaginationParams(
        count: fetchCount,
      );

      if (fetchMore) {
        final pState = state as CursorPaginationModel<RestaurantModel>;
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        params = params.copyWith(
          after: pState.data.last.id,
        );
      } else {
        if (state is CursorPaginationModel && forceRefetch) {
          final pState = state as CursorPaginationModel;
          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final response = await repository.paginate(
        paginationParams: params,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationModel<RestaurantModel>;
        state = response.copyWith(
          data: [
            ...pState.data,
            ...response.data,
          ],
        );
      }
      else {
        state = response;
      }
    }
    catch (e) {
      state = CursorPaginationError(message: "에러 발생");
    }
  }

  Future<void> getDetail({
    required String id,
  }) async {
    if (state is! CursorPaginationModel) {
      await paginate();
    }

    if (state is! CursorPaginationModel) return;

    final pState = state as CursorPaginationModel;

    final response = await repository.getRestaurantDetailModel(id: id);

    state = pState.copyWith(
      meta: pState.meta,
      data: pState.data
          .map<RestaurantModel>((e) => e.id == id ? response : e)
          .toList(),
    );
  }
}
