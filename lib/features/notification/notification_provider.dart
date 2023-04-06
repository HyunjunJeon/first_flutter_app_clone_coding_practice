import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:flutter_tiktok_clone/features/videos/views/video_recording_screen.dart';
import 'package:go_router/go_router.dart';

class NotificationProvider extends FamilyAsyncNotifier<void, BuildContext> {
  late final FirebaseFirestore _database = FirebaseFirestore.instance;
  late final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    await _database.collection("users").doc(user!.uid).update({"token": token});
  }

  Future<void> initListener(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) return;

    // Foreground - 앱이 켜져 있을 때 알림을 보내는 방법
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("I just got a message and I'm in foreground.");
      print(message.notification?.title);
    });

    // Background - 앱이 백그라운드로 가 있는 경우
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("I just got a message and I'm in background.");
      print(message.data);
      context.pushNamed(ChatsScreen.routeName);
    });

    // Terminated - 앱이 완전히 종료된 상태에서 사용자가 알림을 누르고 깨어났을 때
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {
      print(notification.data);
      context.pushNamed(VideoRecodingScreen.routeName);
    }
  }

  @override
  FutureOr<void> build(BuildContext context) async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);
    await initListener(context);
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationProvider = AsyncNotifierProvider.family(
  () => NotificationProvider(),
);
