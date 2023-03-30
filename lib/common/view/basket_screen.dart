import 'package:delivery_app_project/common/const/colors.dart';
import 'package:delivery_app_project/common/layout/default_layout.dart';
import 'package:delivery_app_project/order/provider/order_provider.dart';
import 'package:delivery_app_project/order/view/order_done_screen.dart';
import 'package:delivery_app_project/product/component/product_card.dart';
import 'package:delivery_app_project/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static const String routeName = "basket";

  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return const DefaultLayout(
        title: "장바구니",
        child: Center(
          child: Text(
            "장바구니가 비어있습니다 ㅠㅠ",
          ),
        ),
      );
    }

    final basketPrice = basket.fold<int>(
      0,
      (previousValue, element) =>
          previousValue + (element.count * element.product.price),
    );

    final deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
      title: "장바구니",
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    final product = basket[index].product;
                    return ProductCard.fromProductModel(
                      model: product,
                      onAdd: () {
                        ref.read(basketProvider.notifier).addBasketItem(
                              product: product,
                            );
                      },
                      onSubtract: () {
                        ref.read(basketProvider.notifier).remoteBasketItem(
                              product: product,
                            );
                      },
                    );
                  },
                  separatorBuilder: (_, index) {
                    return Divider(
                      height: 32.0,
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "장바구니 금액",
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      Text("￦$basketPrice"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "배달",
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      Text("￦$deliveryFee"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "총액",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text("￦${deliveryFee + basketPrice}"),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final response =
                            await ref.read(orderProvider.notifier).postOrder();

                        if (response) {
                          context.goNamed(OrderDoneScreen.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("결제 실패"),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR),
                      child: Text("결제하기"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
