import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/view_models/timeline_view_model.dart';
import 'package:flutter_tiktok_clone/features/videos/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({Key? key}) : super(key: key);

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Curve _scrollCurve = Curves.linear;

  int _itemCount = 0;

  void _onPageChanged(int page) {
    // infinite scroll
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      ref.watch(timelineProvider.notifier).fetchNextPage();
    }
  }

  final PageController _pageController = PageController();

  void _onVideoFinished() {
    return; // 영상이 끝나도 다음 영상으로 넘어가지 않고 멈춤(Youtube Short 와 다르게 Tiktok 은 반복 재생을 함)
    // _pageController.nextPage(
    //   duration: _scrollDuration,
    //   curve: _scrollCurve,
    // );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    // onRefresh 는 항상 Future 를 반환해야함
    // return Future.delayed(
    //   const Duration(
    //     seconds: 5, // 일부러 5초정도 리프레쉬 하는게 있는 것처럼 보여줌
    //   ),
    // );
    return ref.watch(timelineProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    // 성능을 위해서 그냥 PageView 가 아닌 ListView.builder 처럼 PageView.builder 를 사용
    return ref.watch(timelineProvider).when(
          // Async 이기 때문에 이런식으로 사용 가능
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "$error & $stackTrace",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          data: (videos) {
            _itemCount = videos.length;
            return RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 40,
              edgeOffset: 20,
              color: Theme.of(context).primaryColor,
              child: PageView.builder(
                pageSnapping: true,
                scrollDirection: Axis.vertical,
                itemCount: videos.length,
                onPageChanged: _onPageChanged,
                controller: _pageController,
                itemBuilder: (context, index) {
                  final videoData = videos[index];
                  return VideoPost(
                    onVideoFinished: _onVideoFinished,
                    index: index,
                    videoData: videoData,
                  );
                },
              ),
            );
          },
        );
  }
}
