import 'dart:convert';

import 'package:delivery_app_project/common/component/custom_text_field.dart';
import 'package:delivery_app_project/common/const/colors.dart';
import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/layout/default_layout.dart';
import 'package:delivery_app_project/common/secure_storage/secure_storage_provider.dart';
import 'package:delivery_app_project/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String userName = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    final Dio dio = Dio();

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(
                  height: 16.0,
                ),
                const _SubTitle(),
                const SizedBox(
                  height: 16.0,
                ),
                Image.asset(
                  "asset/img/misc/logo.png",
                  width: MediaQuery.of(context).size.width * 2 / 3,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextFormField(
                  hintText: "이메일을 입력해주세요.",
                  onChanged: (String value) {
                    userName = value;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextFormField(
                  hintText: "비밀번호를 입력해주세요.",
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    var url = "$domain/auth/login";
                    var userData = "$userName:$password";
                    var codec = utf8.fuse(base64);
                    var stringToBase64 = codec.encode(userData);
                    var response = await dio.post(
                      url,
                      options: Options(
                        headers: {
                          "Authorization": "Basic $stringToBase64",
                        },
                      ),
                    );

                    var refreshToken = response.data["refreshToken"];
                    var accessToken = response.data["accessToken"];
                    final storage = ref.read(secureStorageProvider);

                    await storage.write(
                        key: refreshTokenKey, value: refreshToken);
                    await storage.write(
                        key: accessTokenKey, value: accessToken);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => RootTab()),
                        (route) => false);
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
                  child: Text("로그인"),
                ),
                TextButton(
                  onPressed: () async {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Text("회원가입"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "환영합니다!",
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "이메일과 비빌번호를 등록해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)",
      style: TextStyle(
        color: BODY_TEXT_COLOR,
        fontSize: 16,
      ),
    );
  }
}
