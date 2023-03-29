import 'package:json_annotation/json_annotation.dart';

part 'basket_patch_body.g.dart';

@JsonSerializable()
class BasketPatchBody {
  final String productId;
  final int count;

  BasketPatchBody({
    required this.productId,
    required this.count,
  });

  Map<String, dynamic> toJson() => _$BasketPatchBodyToJson(this);
}
