import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:delivery_app_project/product/model/product_model.dart';
import 'package:delivery_app_project/user/model/basket_item_model.dart';
import 'package:delivery_app_project/user/model/basket_patch_body.dart';
import 'package:delivery_app_project/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketStateNotifier, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  return BasketStateNotifier(
    repository: repository,
  );
});

class BasketStateNotifier extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  final updateDebouncer = Debouncer(
    const Duration(seconds: 1),
    initialValue: null,
    checkEquality: false,
  );

  BasketStateNotifier({
    required this.repository,
  }) : super([]) {
    updateDebouncer.values.listen((event) {
      patchBasket();
    });
  }

  Future<void> patchBasket() async {
    repository.patchBasket(
        body: BasketPatchBody(
      basket: state
          .map(
            (e) => BasketPatchBodyBasket(
              productId: e.product.id,
              count: e.count,
            ),
          )
          .toList(),
    ));
  }

  Future<void> addBasketItem({
    required ProductModel product,
  }) async {
    final exist =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exist) {
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count + 1) : e,
          )
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        ),
      ];
    }

    updateDebouncer.setValue(null);
  }

  Future<void> remoteBasketItem({
    required ProductModel product,
    bool isDelete = false,
  }) async {
    final existingProduct =
        state.firstWhereOrNull((e) => e.product.id == product.id);

    if (existingProduct == null) return;

    if (existingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
      return;
    }

    state = state
        .map((e) =>
            e.product.id != product.id ? e : e.copyWith(count: e.count - 1))
        .toList();

    updateDebouncer.setValue(null);
  }
}
