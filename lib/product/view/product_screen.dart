import 'package:delivery_app_project/common/component/pagination_list_view.dart';
import 'package:delivery_app_project/product/component/product_card.dart';
import 'package:delivery_app_project/product/model/product_model.dart';
import 'package:delivery_app_project/product/provider/product_provider.dart';
import 'package:delivery_app_project/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, model) {
          return GestureDetector(
            onTap: () {
              context.goNamed(RestaurantDetailScreen.routeName, params: {
                "rid": model.restaurant.id,
              });
            },
            child: ProductCard.fromProductModel(model: model),
          );
        });
  }
}
