import 'package:delivery_app_project/user/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.read(authProvider);
  return GoRouter(
    initialLocation: "/splash",
    routes: auth.routes,
    redirect: auth.redirectionLogic,
    refreshListenable: auth,
  );
});
