import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/models/video_model.dart';
import 'package:flutter_tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];
  late final VideosRepository _repository;

  @override
  FutureOr<List<VideoModel>> build() async {
    // API 를 호출한다고 가정하는데, 지연되고 있다고 가정
    // await Future.delayed(const Duration(seconds: 5));
    _repository = ref.read(videosRepo);
    _list = await _fetchVideos(lastItemCreatedAt: null);
    return _list;
  }

  _fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final result = await _repository.fetchVideos(lastItemCreatedAt: null);
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );
    return videos.toList();
  }

  Future<void> fetchNextPage() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    _list = [..._list, ...nextPage];
    state = AsyncValue.data(_list);
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos(lastItemCreatedAt: null);
    _list = videos;
    state = const AsyncValue.loading();
    state = AsyncValue.data(_list);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
