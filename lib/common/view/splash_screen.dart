import 'package:delivery_app_project/common/const/colors.dart';
import 'package:delivery_app_project/common/const/data.dart';
import 'package:delivery_app_project/common/layout/default_layout.dart';
import 'package:delivery_app_project/common/view/root_tab.dart';
import 'package:delivery_app_project/user/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() async {
    final accessToken = await storage.read(key: accessTokenKey);
    final refreshToken = await storage.read(key: refreshTokenKey);

    if (!mounted) return;

    if (accessToken == null || refreshToken == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,);
    }
    else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RootTab()),
            (route) => false,);
    }
  }

  @override
  Widget build(BuildContext context) {
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
