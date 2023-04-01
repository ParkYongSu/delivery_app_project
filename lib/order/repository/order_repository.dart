import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/dio/custom_interceptor.dart';
import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/model/pagination_params.dart';
import 'package:delivery_app_project/common/repository/base_pagination_repository.dart';
import 'package:delivery_app_project/order/model/order_model.dart';
import 'package:delivery_app_project/order/model/post_order_body.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRepository(dio, baseUrl: "$domain/order");
});

@RestApi()
abstract class OrderRepository implements IBasePaginationRepository<OrderModel> {
  factory OrderRepository(Dio dio, {required String baseUrl}) =
      _OrderRepository;

  @GET("/")
  @Headers({
    "accessToken": "true",
  })
  @override
  Future<CursorPaginationModel<OrderModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @POST("/")
  @Headers({
    "accessToken": "true",
  })
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}