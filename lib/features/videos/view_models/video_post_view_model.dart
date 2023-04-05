import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<bool, String> {
  late final VideosRepository _repository;
  late final String _videoId;
  late final String _userId;
  bool _isLiked = false;

  @override
  FutureOr<bool> build(String arg) async {
    _videoId = arg;
    _userId = ref.read(autoRepo).user!.uid;
    _repository = ref.refresh(videosRepo);
    _isLiked =
        await _repository.isLikedVideo(videoId: _videoId, userId: _userId);
    return _isLiked;
  }

  Future<void> toggleVideoLike() async {
    final liked = await _repository.toggleVideoLike(_videoId, _userId);
    _isLiked = liked;
    state = const AsyncLoading();
    state = AsyncData(_isLiked);
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, bool, String>(
  () => VideoPostViewModel(),
);
