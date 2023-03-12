import 'package:flutter_tiktok_clone/features/videos/video_recording_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => const VideoRecodingScreen(),
  )
]);
