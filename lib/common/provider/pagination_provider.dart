import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/model/model_with_id.dart';
import 'package:delivery_app_project/common/model/pagination_params.dart';
import 'package:delivery_app_project/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PaginationInfo {
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PaginationStateNotifier<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final _paginationThrottle = Throttle(
    const Duration(seconds: 1),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
    _paginationThrottle.values.listen((state) {
      _throttlePagination(state);
    });
  }

  paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) {
    _paginationThrottle.setValue(
      _PaginationInfo(
        fetchCount: fetchCount,
        fetchMore: fetchMore,
        forceRefetch: forceRefetch,
      ),
    );
  }

  Future<void> _throttlePagination(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;
    print(forceRefetch);
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
    } catch (e) {
      state = CursorPaginationError(message: "에러 발생");
    }
  }
}
