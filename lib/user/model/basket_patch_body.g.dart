// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_patch_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketPatchBody _$BasketPatchBodyFromJson(Map<String, dynamic> json) =>
    BasketPatchBody(
      basket: (json['basket'] as List<dynamic>)
          .map((e) => BasketPatchBodyBasket.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BasketPatchBodyToJson(BasketPatchBody instance) =>
    <String, dynamic>{
      'basket': instance.basket,
    };

BasketPatchBodyBasket _$BasketPatchBodyBasketFromJson(
        Map<String, dynamic> json) =>
    BasketPatchBodyBasket(
      productId: json['productId'] as String,
      count: json['count'] as int,
    );

Map<String, dynamic> _$BasketPatchBodyBasketToJson(
        BasketPatchBodyBasket instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'count': instance.count,
    };
