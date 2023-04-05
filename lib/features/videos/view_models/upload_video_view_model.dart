import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_tiktok_clone/features/videos/models/video_model.dart';
import 'package:flutter_tiktok_clone/features/videos/repos/videos_repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _videosRepository;
  late final AuthenticationRepository _authRepository;

  @override
  FutureOr<void> build() {
    _videosRepository = ref.read(videosRepo);
    _authRepository = ref.read(autoRepo);
  }

  Future<void> uploadVideo(File video) async {
    final user = _authRepository.user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () async {
          final uploadTask =
              await _videosRepository.uploadVideoFile(video, user!.uid);

          if (uploadTask.metadata != null) {
            await _videosRepository.saveVideo(VideoModel(
              id: "",
              title: "sample flutter videos",
              description: "yeah",
              fileUrl: await uploadTask.ref.getDownloadURL(),
              thumbnailUrl: "",
              creatorUid: user.uid,
              likes: 0,
              comments: 0,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              creator: userProfile.name,
            ));
          }
        },
      );
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
