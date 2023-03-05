import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/main_navigation/main_navigation_screen.dart';

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
      themeMode: ThemeMode.system, // light vs dart Mode 결정하는 것을 기기의 환경에 맞춤
      theme: ThemeData(
        // 최대한 공통이 되는 Theme Data 는 모아두기(Material Design 에서만 사용 가능)
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
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
        bottomAppBarTheme: BottomAppBarTheme(
          // 앱 전체에 적용되게끔 공통 설정을 해줄 수도 있고
          color: Colors.grey.shade50,
        ),
        textTheme: Typography.blackMountainView,
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade500,
          // Flutter 버전을 3.3.10 => 3.7.6 으로 업그레이드 했음
          indicatorColor: Colors.black,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
        ),
        // textTheme: GoogleFonts.itimTextTheme(),
        // https://m2.material.io/design/typography/the-type-system.html#type-scale
        // textTheme: TextTheme(
        //   headline1: GoogleFonts.openSans(
        //     fontSize: 96,
        //     fontWeight: FontWeight.w300,
        //     letterSpacing: -1.5,
        //   ),
        //   headline2: GoogleFonts.openSans(
        //       fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        //   headline3:
        //       GoogleFonts.openSans(fontSize: 48, fontWeight: FontWeight.w400),
        //   headline4: GoogleFonts.openSans(
        //       fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        //   headline5:
        //       GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w400),
        //   headline6: GoogleFonts.openSans(
        //       fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        //   subtitle1: GoogleFonts.openSans(
        //       fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        //   subtitle2: GoogleFonts.openSans(
        //       fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        //   bodyText1: GoogleFonts.roboto(
        //       fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        //   bodyText2: GoogleFonts.roboto(
        //       fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        //   button: GoogleFonts.roboto(
        //       fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        //   caption: GoogleFonts.roboto(
        //       fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        //   overline: GoogleFonts.roboto(
        //       fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        // ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE9435A),
        brightness: Brightness.dark, // Text Widget 의 기본 색깔이 바뀜
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade800,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          // CupertinoSearchTextField 의 커서 색깔을 바꾸는 옵션이없는데, 이거는 여기서 바꿔줄 수 있음
          cursorColor: Color(0xFFE9435A),
        ),
        textTheme: Typography.whiteMountainView,
        // textTheme: GoogleFonts.itimTextTheme(
        //   ThemeData(
        //     brightness: Brightness.dark,
        //   ).textTheme,
        // ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
        ),
        tabBarTheme: const TabBarTheme(
          indicatorColor: Colors.white,
        ),
      ), // darkMode ThemeData 를 구성
      home: const MainNavigationScreen(),
    );
  }
}

// MediaQuery 와 LayoutBuilder 을 테스트 해봄
class LayoutBuilderCodeLab extends StatelessWidget {
  const LayoutBuilderCodeLab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width / 2,
        // LayoutBuilder 는 어디에 있는지에 따라 화면의 크기를 알려줄수도, Widget 사이즈를 알려줄 수도 있음
        // 부모 Widget 의 크기를 알고 싶을 떄 사용하면 좋음, 어느정도 커질 수 있는지 알고 싶을 때
        child: LayoutBuilder(
          // LayoutBuilder 는 builder 내에 속한 Widget 의 크기를 나타냄
          builder: (context, constraints) => Container(
            // 여기서는 이 Container Widget 이 가질 수 있는 최대 width
            width: constraints.maxWidth,
            // 여기서는 이 Container Widget 이 가질 수 있는 최대 height
            height: constraints.maxHeight,
            color: Colors.teal,
            child: Center(
              child: Text(
                "${size.width}, ${constraints.maxWidth}",
                style: const TextStyle(color: Colors.white, fontSize: 100),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
