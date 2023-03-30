import 'package:delivery_app_project/common/const/colors.dart';
import 'package:delivery_app_project/common/layout/default_layout.dart';
import 'package:delivery_app_project/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDoneScreen extends StatelessWidget {
  static const String routeName = "orderDone";

  const OrderDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.thumb_up_alt_outlined,
              size: 50.0,
              color: PRIMARY_COLOR,
            ),
            const SizedBox(
              height: 32.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "결제가 완료되었습니다.",
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
              onPressed: () {
                context.goNamed(RootTab.routeName);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR
              ),
              child: Text("홈으로"),
            ),
          ],
        ),
      ),
    );
  }
}
