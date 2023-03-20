import 'package:delivery_app_project/common/model/model_with_id.dart';
import 'package:delivery_app_project/common/utils/data_utils.dart';
import 'package:delivery_app_project/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements IModelWithId {
  @override
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;
  final RestaurantModel restaurant;

  ProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
    required this.restaurant,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) 
  => _$ProductModelFromJson(json);
}
