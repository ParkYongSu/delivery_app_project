import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final BottomNavigationBar? bottomNavigationBar;

  const DefaultLayout({
    Key? key,
    this.backgroundColor,
    required this.child,
    this.title,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(),
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
    );
  }

  AppBar? _renderAppBar() {
    if (title == null) return null;

    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      title: Text(
        title!,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

}
