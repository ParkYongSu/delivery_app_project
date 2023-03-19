import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/model/model_with_id.dart';
import 'package:delivery_app_project/common/model/pagination_params.dart';
import 'package:delivery_app_project/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationStateNotifier<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationStateNotifier({
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
        final pState = state as CursorPaginationModel<T>;
        state = CursorPaginationFetchingMore<T>(
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
        final pState = state as CursorPaginationModel;
        state = response.copyWith(
          data: [
            ...pState.data,
            ...response.data,
          ],
        );
      } else {
        state = response;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: "에러 발생");
    }
  }
}
