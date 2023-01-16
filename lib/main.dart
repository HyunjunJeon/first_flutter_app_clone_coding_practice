import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';

import 'features/authentication/sign_up_screen.dart';

void main() {
  runApp(const TikTokCloneApp());
}

class TikTokCloneApp extends StatelessWidget {
  const TikTokCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok Clone',
      theme: ThemeData(
        // 최대한 공통이 되는 Theme Data 는 모아두기
        primaryColor: const Color(0xFFE9435A),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          // AppBar Theme Data 적용되는 부분
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: Sizes.size0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.size20,
          ),
        ),
      ),
      home: const SignUpScreen(),
    );
  }
}
