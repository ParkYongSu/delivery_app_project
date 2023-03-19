import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/dio/custom_interceptor.dart';
import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/model/pagination_params.dart';
import 'package:delivery_app_project/common/repository/base_pagination_repository.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RestaurantRepository(dio, baseUrl: "$domain/restaurant");
});

@RestApi()
abstract class RestaurantRepository
    implements IBasePaginationRepository<RestaurantModel> {
  factory RestaurantRepository(Dio dio, {required String baseUrl}) =
      _RestaurantRepository;

  @GET("/")
  @Headers({
    "accessToken": "true",
  })
  @override
  Future<CursorPaginationModel<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET("/{id}")
  @Headers({
    "accessToken": "true",
  })
  Future<RestaurantDetailModel> getRestaurantDetailModel({
    @Path() required String id,
  });
}
