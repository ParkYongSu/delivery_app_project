import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/restaurant/component/restaurant_card.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:delivery_app_project/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> _paginateRestaurant() async {
    final accessToken = await storage.read(key: accessTokenKey);

    final dio = Dio();

    final response = await dio.get("$domain/restaurant",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}));

    return response.data["data"];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: FutureBuilder<List>(
          future: _paginateRestaurant(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.separated(
              itemBuilder: (_, index) {
                final item = snapshot.data![index];
                final pItem = RestaurantModel.fromJson(item);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RestaurantDetailScreen(
                                  id: pItem.id,
                                )));
                  },
                  child: RestaurantCard.fromModel(
                    model: pItem,
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return SizedBox(
                  height: 16.0,
                );
              },
              itemCount: snapshot.data!.length,
            );
          },
        ),
      ),
    );
  }
}
