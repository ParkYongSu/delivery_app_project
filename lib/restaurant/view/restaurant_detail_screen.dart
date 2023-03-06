import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/layout/default_layout.dart';
import 'package:delivery_app_project/product/component/product_card.dart';
import 'package:delivery_app_project/restaurant/component/restaurant_card.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({Key? key, required this.id}) : super(key: key);

  Future<Map<String, dynamic>> _getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await storage.read(
      key: accessTokenKey,
    );

    var response = await dio.get(
      "$domain/restaurant/$id",
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "불타는 떡볶이",
      child: FutureBuilder<Map<String, dynamic>>(
        future: _getRestaurantDetail(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final item = RestaurantDetailModel.fromJson(
            json: snapshot.data!,
          );

          return CustomScrollView(
            slivers: [
              _renderTop(
                model: item,
              ),
              _renderLabel(),
              _renderList(models: item.products),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _renderTop({required RestaurantDetailModel model}) {
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
}
