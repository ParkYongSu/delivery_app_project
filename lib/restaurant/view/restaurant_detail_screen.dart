import 'package:delivery_app_project/common/layout/default_layout.dart';
import 'package:delivery_app_project/product/component/product_card.dart';
import 'package:delivery_app_project/restaurant/component/restaurant_card.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:delivery_app_project/restaurant/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RestaurantDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: "불타는 떡볶이",
      child: CustomScrollView(
        slivers: [
          _renderTop(
            model: state,
          ),
          if (state is! RestaurantDetailModel) _renderLoading(),
          if (state is RestaurantDetailModel) _renderLabel(),
          if (state is RestaurantDetailModel)
            _renderList(
              models: state.products,
            ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _renderTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding _renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          "메뉴",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  SliverPadding _renderList({
    required List<RestaurantProductModel> models,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            return Padding(
              padding: EdgeInsets.only(
                top: 8.0,
              ),
              child: ProductCard.fromModel(
                model: models[index],
              ),
            );
          },
          childCount: models.length,
        ),
      ),
    );
  }

  SliverPadding _renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: 32.0,
                ),
                child: SkeletonParagraph(
                      style: const SkeletonParagraphStyle(
                        padding: EdgeInsets.zero,
                        lines: 5,
                      ),
                    ),
              )),
        ),
      ),
    );
  }
}
