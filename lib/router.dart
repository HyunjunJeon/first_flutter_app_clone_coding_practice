import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/login_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:flutter_tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:flutter_tiktok_clone/features/videos/views/video_recording_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider(
  (ref) {
    // ref.watch(authState);
    return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final bool isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeURL,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: InterestsScreen.routeName,
          path: InterestsScreen.routeURL,
          builder: (context, state) => const InterestsScreen(),
        ),
        GoRoute(
          name: MainNavigationScreen.routeName,
          path: "/:tab(home|discover|inbox|profile)",
          builder: (context, state) {
            final String param = state.params["tab"]!;
            final NavigationTab byName = NavigationTab.values.byName(param);
            return MainNavigationScreen(tab: byName);
          },
        ),
        GoRoute(
          name: ActivityScreen.routeName,
          path: ActivityScreen.routeURL,
          builder: (context, state) => const ActivityScreen(),
        ),
        GoRoute(
          name: ChatsScreen.routeName,
          path: ChatsScreen.routeURL,
          builder: (context, state) => const ChatsScreen(),
          routes: [
            GoRoute(
              path: ChatDetailScreen.routeURL,
              name: ChatDetailScreen.routeName,
              builder: (context, state) {
                final String chatId = state.params["chatId"]!;
                return ChatDetailScreen(chatId: chatId);
              },
            ),
          ],
        ),
        GoRoute(
          name: VideoRecodingScreen.routeName,
          path: VideoRecodingScreen.routeURL,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const VideoRecodingScreen(),
            transitionDuration: const Duration(milliseconds: 150),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              final position = Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(
                position: position,
                child: child,
              );
            },
          ),
        ),
      ],
    );
  },
);
