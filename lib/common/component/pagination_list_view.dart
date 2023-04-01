import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/model/model_with_id.dart';
import 'package:delivery_app_project/common/provider/pagination_provider.dart';
import 'package:delivery_app_project/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationStateNotifier, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    Key? key,
    required this.provider,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    PaginationUtils.paginate(
      controller: _scrollController,
      stateNotifier: ref.read(widget.provider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    if (state is CursorPaginationLoading || state is CursorPaginationRefetching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is CursorPaginationError) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              state.message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(widget.provider.notifier).paginate(
                      forceRefetch: true,
                    );
              },
              child: Text("다시 시도"),
            ),
          ]);
    }

    final cp = state as CursorPaginationModel<T>;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(widget.provider.notifier).paginate(
            forceRefetch: true,
          );
        },
        child: ListView.separated(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: cp is CursorPaginationFetchingMore
                      ? CircularProgressIndicator()
                      : Text("마지막 데이터 ㅠ"),
                ),
              );
            }

            final pItem = cp.data[index];

            return widget.itemBuilder(
              context,
              pItem,
            );
          },
          separatorBuilder: (_, index) {
            return SizedBox(
              height: 16.0,
            );
          },
          itemCount: cp.data.length + 1,
        ),
      ),
    );
    return Container();
  }
}
