import 'package:delivery_app_project/common/model/cursor_pagination_model.dart';
import 'package:delivery_app_project/common/provider/pagination_provider.dart';
import 'package:delivery_app_project/order/model/order_model.dart';
import 'package:delivery_app_project/order/model/post_order_body.dart';
import 'package:delivery_app_project/order/repository/order_repository.dart';
import 'package:delivery_app_project/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);

  return OrderStateNotifier(
    ref: ref,
    repository: repository,
  );
});

class OrderStateNotifier extends PaginationStateNotifier<OrderModel, OrderRepository>{
  final Ref ref;

  OrderStateNotifier({required this.ref, required super.repository});

  Future<bool> postOrder() async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      final baskets = ref.read(basketProvider);

      final response = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: baskets
              .map(
                (e) => PostOrderBodyProduct(
                  productId: e.product.id,
                  count: e.count,
                ),
              )
              .toList(),
          totalPrice: baskets.fold<int>(
            0,
            (previousValue, element) =>
                previousValue + (element.count * element.product.price),
          ),
          createdAt: DateTime.now().toString(),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
