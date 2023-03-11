import 'package:flutter_tiktok_clone/features/authentication/email_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/login_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/username_screen.dart';
import 'package:flutter_tiktok_clone/features/users/user_profile_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: SignUpScreen.routeName,
    builder: (context, state) => const SignUpScreen(),
  ),
  GoRoute(
    path: LoginScreen.routeName,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: UsernameScreen.routeName,
    builder: (context, state) => const UsernameScreen(),
  ),
  GoRoute(
    path: EmailScreen.routeName,
    builder: (context, state) {
      final args = state.extra as EmailScreenArgs;
      return EmailScreen(username: args.username);
    },
  ),
  GoRoute(
    path: "/users/:username",
    builder: (context, state) {
      final username = state.params['username'];
      // ??= null-aware assignment operator: 변수가 null 이면 값을 할당하고, 아니면 값을 유지하는 연산자
      String? tab = state.queryParams["show"];
      tab ??= "posts";
      return UserProfileScreen(username: username!, tab: tab);
    },
  ),
]);
