import 'package:delivery_app_project/common/component/pagination_list_view.dart';
import 'package:delivery_app_project/restaurant/component/restaurant_card.dart';
import 'package:delivery_app_project/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app_project/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, model) {
        return GestureDetector(
          onTap: () {
            // context.go("/restaurant/${model.id}");
            context.goNamed(RestaurantDetailScreen.routeName, params: {
              "rid" : model.id,
            });
          },
          child: RestaurantCard.fromModel(
            model: model,
          ),
        );
      },
    );
  }
}
