import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).muted,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setMuted(value),
            title: const Text("Mute Video"),
            subtitle: const Text("Videos will be muted by default."),
          ),
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).autoplay,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setAutoplay(value),
            title: const Text("Autoplay"),
            subtitle: const Text("Videos will start playing automatically"),
          ),

          // SwitchListTile.adaptive(
          //   value: context.watch<PlaybackConfigViewModel>().muted,
          //   onChanged: (value) =>
          //       context.read<PlaybackConfigViewModel>().setMuted(value),
          //   title: const Text("Mute Video"),
          //   subtitle: const Text("Videos will be muted by default."),
          // ),
          // SwitchListTile.adaptive(
          //   value: context.watch<PlaybackConfigViewModel>().autoplay,
          //   onChanged: (value) =>
          //       context.read<PlaybackConfigViewModel>().setAutoplay(value),
          //   title: const Text("Autoplay"),
          //   subtitle: const Text("Videos will start playing automatically"),
          // ),
          // AnimatedBuilder 를 사용하면 딱 이부분의 데이터만 변경하는게 가능해서 ChangeNotifiter 와 사용하기 좋음
          // AnimatedBuilder(
          //   builder: (context, child) => SwitchListTile.adaptive(
          //     value: videoConfig.autoMute,
          //     onChanged: (value) {
          //       videoConfig.toggleMute();
          //     },
          //     title: const Text("Auto Mute"),
          //     subtitle: const Text("Videos will be muted by default."),
          //   ),
          //   animation: videoConfig,
          // ),
          CupertinoSwitch(
            value: false,
            onChanged: (value) {},
          ),
          // Switch.adaptive(
          //   value: _notification,
          //   onChanged: _onNotificationChange,
          // ),
          // Switch(
          //   value: _notification,
          //   onChanged: _onNotificationChange,
          // ),
          // SwitchListTile(
          //   value: _notification,
          //   onChanged: _onNotificationChange,
          //   title: const Text("Enable Notification~"),
          // ),
          // SwitchListTile.adaptive(
          //   value: _notification,
          //   onChanged: _onNotificationChange,
          //   title: const Text("Enable Notification~"),
          //   subtitle: const Text("subtitles...."),
          // ),
          // Checkbox(
          //   value: _notification,
          //   onChanged: _onNotificationChange,
          // ),
          // CheckboxListTile(
          //   value: _notification,
          //   onChanged: _onNotificationChange,
          //   title: const Text("Enable notifications"),
          //   checkColor: Colors.white,
          //   activeColor: Theme.of(context).primaryColor,
          // ),
          ListTile(
            // 여러가지 Date, Time, DateRanger 에 관한 연습
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
              );
              print(date);
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              print(time);
              final dateTimeRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              print(dateTimeRange);
            },
            title: const Text(
              "What is your birthday?",
            ),
          ),
          ListTile(
              title: const Text("Log out(iOS)"),
              textColor: Colors.red,
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text("Plz don't go"),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("No"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          ref.read(authRepo).signOut();
                          context.go("/");
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              }),
          ListTile(
              title: const Text("Log out(Android)"),
              textColor: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const FaIcon(FontAwesomeIcons.skull),
                    title: const Text("Are you sure?"),
                    content: const Text("Plz don't go"),
                    actions: [
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.car,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text("Yes"),
                        onPressed: () {
                          ref.read(authRepo).signOut();
                          context.go("/");
                        },
                      ),
                    ],
                  ),
                );
              }),
          ListTile(
              title: const Text("Log out(iOS / Bottom)"),
              textColor: Colors.red,
              onTap: () {
                // showCupertinoDialog 와 다른 점은 밖을 눌렀을 떄 Modal 은 꺼짐
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text("Are you sure?"),
                    message: const Text("Please dooooon't go my girl~"),
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Not log out"),
                      ),
                      CupertinoActionSheetAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          ref.read(authRepo).signOut();
                          context.go("/");
                        },
                        child: const Text("Yes Plz"),
                      ),
                    ],
                  ),
                );
              }),
          const AboutListTile(
            applicationName: "JHJ's Tiktok clone",
            applicationVersion: "0.1",
            applicationLegalese: "All rights reserved.",
          ),
        ],
      ),
    );
  }
}
