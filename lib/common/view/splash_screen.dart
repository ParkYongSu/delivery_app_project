import 'package:delivery_app_project/common/const/colors.dart';
import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/layout/default_layout.dart';
import 'package:delivery_app_project/common/secure_storage/secure_storage_provider.dart';
import 'package:delivery_app_project/common/view/root_tab.dart';
import 'package:delivery_app_project/user/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  static const routeName = "splash";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "asset/img/logo/logo.png",
              width: MediaQuery.of(context).size.width / 2,
            ),
            SizedBox(
              height: 16.0,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
