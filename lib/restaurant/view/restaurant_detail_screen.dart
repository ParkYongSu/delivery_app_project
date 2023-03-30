import 'package:delivery_app_project/common/const/colors.dart';
import 'package:delivery_app_project/common/layout/default_layout.dart';
import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/utils/pagination_utils.dart';
import 'package:delivery_app_project/common/view/basket_screen.dart';
import 'package:delivery_app_project/product/component/product_card.dart';
import 'package:delivery_app_project/product/model/product_model.dart';
import 'package:delivery_app_project/rating/component/rating_card.dart';
import 'package:delivery_app_project/rating/model/rating_model.dart';
import 'package:delivery_app_project/restaurant/component/restaurant_card.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:delivery_app_project/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app_project/restaurant/provider/restaurant_rating_provider.dart';
import 'package:delivery_app_project/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "restaurantDetail";
  final String id;

  const RestaurantDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    PaginationUtils.paginate(
      controller: _scrollController,
      stateNotifier: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: "불타는 떡볶이",
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(BasketScreen.routeName);
        },
        backgroundColor: PRIMARY_COLOR,
        child: Badge(
          isLabelVisible: basket.isNotEmpty,
          backgroundColor: Colors.white,
          label: Text(
            basket
                .fold<int>(
                  0,
                  (previousValue, element) => previousValue + element.count,
                )
                .toString(),
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 10,
            ),
          ),
          child: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),
      ),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _renderTop(
            model: state,
          ),
          if (state is! RestaurantDetailModel) _renderLoading(),
          if (state is RestaurantDetailModel) _renderLabel(),
          if (state is RestaurantDetailModel)
            _renderList(
              restaurant: state,
              models: state.products,
            ),
          if (ratingState is CursorPaginationModel<RatingModel>)
            _renderRatings(
              models: ratingState.data,
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
    required RestaurantModel restaurant,
    required List<RestaurantProductModel> models,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            final model = models[index];
            return Padding(
              padding: EdgeInsets.only(
                top: 8.0,
              ),
              child: InkWell(
                onTap: () {
                  ref.read(basketProvider.notifier).addBasketItem(
                        product: ProductModel(
                          id: model.id,
                          name: model.name,
                          imgUrl: model.imgUrl,
                          detail: model.detail,
                          price: model.price,
                          restaurant: restaurant,
                        ),
                      );
                },
                child: ProductCard.fromRestaurantProductModel(
                  model: model,
                ),
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

  SliverPadding _renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: EdgeInsets.only(
              bottom: 16.0,
            ),
            child: RatingCard.fromModel(
              model: models[index],
            ),
          ),
          childCount: models.length,
        ),
      ),
    );
  }
}
