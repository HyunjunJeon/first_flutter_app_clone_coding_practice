import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/view_models/video_post_view_model.dart';
import 'package:flutter_tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoLikes extends ConsumerWidget {
  final int likes;
  final String videoId;

  const VideoLikes({
    super.key,
    required this.likes,
    required this.videoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(videoPostProvider(videoId)).when(
          data: (data) => GestureDetector(
            onTap: () =>
                ref.read(videoPostProvider(videoId).notifier).toggleVideoLike(),
            child: VideoButton(
              color: data ? Colors.red : Colors.white,
              icon: FontAwesomeIcons.solidHeart,
              text: data ? "$likes" : "0",
            ),
          ),
          error: (
            error,
            stackTrace,
          ) =>
              Container(),
          loading: () => GestureDetector(
            onTap: null,
            child: VideoButton(
              color: Colors.white,
              icon: Icons.favorite,
              text: "$likes",
            ),
          ),
        );
  }
}
