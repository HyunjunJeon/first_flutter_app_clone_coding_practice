import 'package:flutter_tiktok_clone/features/authentication/email_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/username_screen.dart';
import 'package:flutter_tiktok_clone/features/users/user_profile_screen.dart';
import 'package:go_router/go_router.dart';

import 'features/authentication/login_screen.dart';

final router = GoRouter(routes: [
  GoRoute(
    name: SignUpScreen.routeName,
    path: SignUpScreen.routeURL,
    builder: (context, state) => const SignUpScreen(),
    routes: [
      // route 를 nested 하게 작성해서 ex> /users/:id/comments/:commect_num/ ... 등으로 만들 수 있음
      GoRoute(
        name: UsernameScreen.routeName,
        path: UsernameScreen.routeURL,
        builder: (context, state) => const UsernameScreen(),
        routes: [
          GoRoute(
            name: EmailScreen.routeName,
            path: EmailScreen.routeURL,
            builder: (context, state) {
              final args = state.extra as EmailScreenArgs;
              return EmailScreen(username: args.username);
            },
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: LoginScreen.routeName,
    builder: (context, state) => const LoginScreen(),
  ),
  // GoRoute(
  //   name: "username_screen",
  //   path: UsernameScreen.routeName,
  //   pageBuilder: (context, state) {
  //     // page Builder 를 사용해서 페이지가 나올 때 Animation 적용이 가능하다
  //     return CustomTransitionPage(
  //         child: const UsernameScreen(),
  //         transitionDuration: const Duration(seconds: 2),
  //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //           return FadeTransition(
  //             opacity: animation,
  //             child: ScaleTransition(
  //               scale: animation,
  //               child: child,
  //             ),
  //           );
  //         });
  //   },
  // ),
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
