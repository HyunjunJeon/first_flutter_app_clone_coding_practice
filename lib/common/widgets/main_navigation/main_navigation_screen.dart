import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/discover/discover_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/inbox_screen.dart';
import 'package:flutter_tiktok_clone/features/onboarding/widgets/post_video_button.dart';
import 'package:flutter_tiktok_clone/features/users/user_profile_screen.dart';
import 'package:flutter_tiktok_clone/features/videos/video_recording_screen.dart';
import 'package:flutter_tiktok_clone/features/videos/video_timeline_screen.dart';
import 'package:flutter_tiktok_clone/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'widgets/nav_tab.dart';

enum NavigationTab { home, discover, inbox, profile }

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = "mainNavigation";

  final NavigationTab tab;

  const MainNavigationScreen({
    Key? key,
    required this.tab,
  }) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late NavigationTab _selectedTab = widget.tab;

  void _onTap(NavigationTab selectedTab) {
    context.go("/${selectedTab.name}");
    setState(() {
      _selectedTab = selectedTab;
    });
  }

  void _onPostVideoButtonTap() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Scaffold(
    //       appBar: AppBar(title: const Text("Record Videos")),
    //     ),
    //     fullscreenDialog: true,
    //   ),
    // );
    context.pushNamed(VideoRecodingScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset: false, // Keyboard 가 나타날 때 화면이 줄어드는 것을 막기 위해서
      backgroundColor: _selectedTab == NavigationTab.home || isDark
          ? Colors.black
          : Colors.white,
      body: Stack(children: [
        Offstage(
          offstage: _selectedTab != NavigationTab.home,
          child: const VideoTimelineScreen(),
        ),
        Offstage(
          offstage: _selectedTab != NavigationTab.discover,
          child: const DiscoverScreen(),
        ),
        Offstage(
          offstage: _selectedTab != NavigationTab.inbox,
          child: const InboxScreen(),
        ),
        Offstage(
          offstage: _selectedTab != NavigationTab.profile,
          child: const UserProfileScreen(
            username: "sample",
            tab: "",
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        color: _selectedTab.index == 0 || isDark ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: NavigationTab.home.name,
                isSelected: _selectedTab == NavigationTab.home,
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                onTap: () => _onTap(NavigationTab.home),
                selectedIndex: _selectedTab.index,
              ),
              NavTab(
                text: NavigationTab.discover.name,
                isSelected: _selectedTab == NavigationTab.discover,
                icon: FontAwesomeIcons.magnifyingGlass,
                selectedIcon: FontAwesomeIcons.compass,
                onTap: () => _onTap(NavigationTab.discover),
                selectedIndex: _selectedTab.index,
              ),
              Gaps.h24,
              GestureDetector(
                onTap: _onPostVideoButtonTap,
                child: PostVideoButton(
                  inverted: _selectedTab != NavigationTab.home,
                ),
              ),
              Gaps.h24,
              NavTab(
                text: NavigationTab.inbox.name,
                isSelected: _selectedTab == NavigationTab.inbox,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                onTap: () => _onTap(NavigationTab.inbox),
                selectedIndex: _selectedTab.index,
              ),
              NavTab(
                text: NavigationTab.profile.name,
                isSelected: _selectedTab == NavigationTab.profile,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(NavigationTab.profile),
                selectedIndex: _selectedTab.index,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
