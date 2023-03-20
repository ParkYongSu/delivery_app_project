import 'package:delivery_app_project/common/component/pagination_list_view.dart';
import 'package:delivery_app_project/common/utils/pagination_utils.dart';
import 'package:delivery_app_project/restaurant/component/restaurant_card.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:delivery_app_project/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app_project/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantModel>(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(context, model) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => RestaurantDetailScreen(
                      id: model.id,
                    )));
          },
          child: RestaurantCard.fromModel(
            model: model,
          ),
        );
      },
    );
  }
}
