// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_patch_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketPatchBody _$BasketPatchBodyFromJson(Map<String, dynamic> json) =>
    BasketPatchBody(
      productId: json['productId'] as String,
      count: json['count'] as int,
    );

Map<String, dynamic> _$BasketPatchBodyToJson(BasketPatchBody instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'count': instance.count,
    };
