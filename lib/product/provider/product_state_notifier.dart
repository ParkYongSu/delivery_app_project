import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/provider/pagination_provider.dart';
import 'package:delivery_app_project/product/model/product_model.dart';
import 'package:delivery_app_project/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return ProductStateNotifier(repository: repository);
});

class ProductStateNotifier
    extends PaginationStateNotifier<ProductModel, ProductRepository> {
  ProductStateNotifier({
    required super.repository,
  });
}
