import 'package:delivery_app_project/common/view/root_tab.dart';
import 'package:delivery_app_project/common/view/splash_screen.dart';
import 'package:delivery_app_project/restaurant/view/restaurant_detail_screen.dart';
import 'package:delivery_app_project/user/screen/login_screen.dart';
import 'package:delivery_app_project/user/model/user_model.dart';
import 'package:delivery_app_project/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(
      userMeProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  List<GoRoute> get routes => [
        GoRoute(
            path: "/",
            name: RootTab.routeName,
            builder: (_, __) => const RootTab(),
            routes: [
              GoRoute(
                path: "restaurant/:rid",
                name: RestaurantDetailScreen.routeName,
                builder: (_, state) => RestaurantDetailScreen(
                  id: state.params["rid"]!,
                ),
              )
            ]),
        GoRoute(
          path: "/splash",
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: "/login",
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
      ];

  String? redirectionLogic(BuildContext context, GoRouterState state) {
    final user = ref.read(userMeProvider);

    final loggingIn = state.location == "/login";

    if (user == null) {
      return loggingIn ? null : "/login";
    }

    if (user is UserModel) {
      return state.location == "/splash" || loggingIn ? "/" : null;
    }

    if (user is UserModelError) {
      return !loggingIn ? "/login" : null;
    }

    return null;
  }

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }
}
