import 'package:delivery_app_project/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {required String baseUrl}) =
      _RestaurantRepository;

  @GET("/{id}")
  @Headers({
    "accessToken": "true",
  })
  Future<RestaurantDetailModel> getRestaurantDetailModel({
    @Path() required String id,
  });
}
