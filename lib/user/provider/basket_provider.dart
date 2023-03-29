import 'dart:math';

import 'package:delivery_app_project/product/model/product_model.dart';
import 'package:delivery_app_project/user/model/basket_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class BasketStateNotifier extends StateNotifier<List<BasketItemModel>> {
  BasketStateNotifier() : super([]);

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
  }
}
