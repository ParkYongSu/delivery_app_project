import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi(baseUrl: "$domain/restaurant")
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio) = _RestaurantRepository;

  @GET("/")
  @Headers({
    "accessToken": "true",
  })
  Future<CursorPaginationModel<RestaurantModel>> paginate();

  @GET("/{id}")
  @Headers({
    "accessToken": "true",
  })
  Future<RestaurantDetailModel> getRestaurantDetailModel({
    @Path() required String id,
  });
}
