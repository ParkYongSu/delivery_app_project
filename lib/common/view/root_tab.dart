import 'package:delivery_app_project/common/const/colors.dart';
import 'package:delivery_app_project/common/layout/default_layout.dart';
import 'package:delivery_app_project/order/view/order_screen.dart';
import 'package:delivery_app_project/product/view/product_screen.dart';
import 'package:delivery_app_project/restaurant/view/restaurant_screen.dart';
import 'package:delivery_app_project/user/view/profile_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  static const String routeName = "home";
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int _index = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_tabListener);
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    super.dispose();
  }

  void _tabListener() {
    setState(() {
      _index = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "코팩 딜리버리",
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _tabController.animateTo(index);
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,),
            label: "홈"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined,),
              label: "음식"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_outlined,),
              label: "주문"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined,),
              label: "프로필"
          ),
        ],
      ),
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          RestaurantScreen(),
          ProductScreen(),
          OrderScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
