import 'package:delivery_app_project/common/component/pagination_list_view.dart';
import 'package:delivery_app_project/order/component/order_card.dart';
import 'package:delivery_app_project/order/model/order_model.dart';
import 'package:delivery_app_project/order/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, model) => OrderCard.fromModel(model: model),
    );
  }
}
