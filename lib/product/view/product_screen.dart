import 'package:delivery_app_project/common/component/pagination_list_view.dart';
import 'package:delivery_app_project/product/component/product_card.dart';
import 'package:delivery_app_project/product/model/product_model.dart';
import 'package:delivery_app_project/product/provider/product_state_notifier.dart';
import 'package:delivery_app_project/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(context, model) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(
                            id: model.restaurant.id,
                          )));
            },
            child: ProductCard.fromProductModel(model: model),
          );
        });
  }
}
