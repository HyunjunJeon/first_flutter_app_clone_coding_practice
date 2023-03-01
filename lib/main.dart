import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/authentication/sign_up_screen.dart';

void main() async {
  // 꼭 main 의 runApp 이전에 쓰여야함
  WidgetsFlutterBinding.ensureInitialized(); // Flutter Engine 과 Widget 들을 결합시켜줌

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp, // 항상 세로 Up 모드로 고정되게끔(유저가 화면을 돌려도)
    ],
  );

  // 시스템 status bar(시계, 배터리 등 나오는 최상단 부분) - 꼭 여기서 쓸 필욘 없고 모든 화면에서 컨트롤 가능
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  runApp(const TikTokCloneApp());
}

class TikTokCloneApp extends StatelessWidget {
  const TikTokCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // iOS Emulator 에서 debug 글자 안보이게
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      theme: ThemeData(
        // 최대한 공통이 되는 Theme Data 는 모아두기(Material Design 에서만 사용 가능)
        primaryColor: const Color(0xFFE9435A),
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(
          // CupertinoSearchTextField 의 커서 색깔을 바꾸는 옵션이없는데, 이거는 여기서 바꿔줄 수 있음
          cursorColor: Color(0xFFE9435A),
        ),
        splashColor: Colors.transparent, // Material Splash Color 삭제
        highlightColor: Colors.transparent,
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
