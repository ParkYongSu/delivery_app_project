import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/dio/custom_interceptor.dart';
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
abstract class OrderRepository {
  factory OrderRepository(Dio dio, {required String baseUrl}) =
      _OrderRepository;

  @POST("/")
  @Headers({
    "accessToken": "true",
  })
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
