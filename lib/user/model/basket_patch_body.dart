import 'package:json_annotation/json_annotation.dart';

part 'basket_patch_body.g.dart';

@JsonSerializable()
class BasketPatchBody {
  List<BasketPatchBodyBasket> basket;

  BasketPatchBody({required this.basket});

  Map<String, dynamic> toJson() => _$BasketPatchBodyToJson(this);
}

@JsonSerializable()
class BasketPatchBodyBasket {
  final String productId;
  final int count;

  BasketPatchBodyBasket({
    required this.productId,
    required this.count,
  });

  Map<String, dynamic> toJson() => _$BasketPatchBodyBasketToJson(this);

  factory BasketPatchBodyBasket.fromJson(Map<String, dynamic> json)
  => _$BasketPatchBodyBasketFromJson(json);
}
