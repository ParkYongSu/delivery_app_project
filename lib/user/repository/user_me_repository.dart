import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/dio/custom_interceptor.dart';
import 'package:delivery_app_project/user/model/basket_item_model.dart';
import 'package:delivery_app_project/user/model/basket_patch_body.dart';
import 'package:delivery_app_project/user/model/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return UserMeRepository(dio, baseUrl: "$domain/user/me");
});

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {required String baseUrl}) =
  _UserMeRepository;

  @GET("/")
  @Headers({
    "accessToken": "true"
  })
  Future<UserModel> getMe();

  @GET("/basket")
  @Headers({
    "accessToken": "true",
  })
  Future<List<BasketItemModel>> getBasket();

  @PATCH("/basket")
  @Headers({
    "accessToken": "true"
  })
  Future<List<BasketItemModel>> patchBasket({
    @Body() required BasketPatchBody body,
  });
}
