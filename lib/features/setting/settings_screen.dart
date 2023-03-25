import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/common/widgets/video_configuration/video_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notification = false;

  void _onNotificationChange(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notification = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: VideoConfigData.of(context).autoMute,
            onChanged: (value) {
              VideoConfigData.of(context).toggleMuted();
            },
            title: const Text("Auto Mute"),
            subtitle: const Text("Videos will be muted by default."),
          ),
          CupertinoSwitch(
            value: _notification,
            onChanged: _onNotificationChange,
          ),
          Switch.adaptive(
            value: _notification,
            onChanged: _onNotificationChange,
          ),
          Switch(
            value: _notification,
            onChanged: _onNotificationChange,
          ),
          SwitchListTile(
            value: _notification,
            onChanged: _onNotificationChange,
            title: const Text("Enable Notification~"),
          ),
          SwitchListTile.adaptive(
            value: _notification,
            onChanged: _onNotificationChange,
            title: const Text("Enable Notification~"),
            subtitle: const Text("subtitles...."),
          ),
          Checkbox(
            value: _notification,
            onChanged: _onNotificationChange,
          ),
          CheckboxListTile(
            value: _notification,
            onChanged: _onNotificationChange,
            title: const Text("Enable notifications"),
            checkColor: Colors.white,
            activeColor: Theme.of(context).primaryColor,
          ),
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
                    child: child!,
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
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
                        child: const Text("Yes"),
                        isDestructiveAction: true,
                        onPressed: () => Navigator.of(context).pop(),
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
                        onPressed: () => Navigator.of(context).pop(),
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
                        onPressed: () => Navigator.of(context).pop(),
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
