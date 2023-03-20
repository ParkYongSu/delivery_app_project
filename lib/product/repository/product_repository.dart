import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/dio/custom_interceptor.dart';
import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/model/pagination_params.dart';
import 'package:delivery_app_project/common/repository/base_pagination_repository.dart';
import 'package:delivery_app_project/product/model/product_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'product_repository.g.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return ProductRepository(dio, baseUrl: '$domain/product');
});

@RestApi()
abstract class ProductRepository
    implements IBasePaginationRepository<ProductModel> {
  factory ProductRepository(Dio dio, {required String baseUrl}) =
      _ProductRepository;

  @GET("/")
  @Headers({
    "accessToken": "true",
  })
  @override
  Future<CursorPaginationModel<ProductModel>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
