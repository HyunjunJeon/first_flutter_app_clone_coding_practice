import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:flutter_tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  const VideoPost({
    Key? key,
    required this.onVideoFinished,
    required this.index,
  }) : super(key: key);

  final Function onVideoFinished;
  final int index;

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin: 위젯이 화면에 보일 때만(current tree) Ticker(시계)를 제공하는데, 이 시계는 매 프레임마다 Animation을 실행시키기 위함
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/sample_video.MOV");

  bool _isPaused = false;
  final Duration _animationDuration = const Duration(milliseconds: 150);

  late final AnimationController _animationController;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true); // 반복 재생
    setState(() {});
    _videoPlayerController.addListener(_onVideoChange);
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this, // 애니메이션 재생을 도와주고, 위젯이 위젯 트리에 있을때만 Ticker 를 유지
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  void _onVisibilityChange(VisibilityInfo info) {
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse(); // 애니메이션 컨트롤러에 정의한 것을 역재생
    } else {
      _videoPlayerController.play();
      _animationController.forward(); // 애니메이션 컨트롤러에 정의한 것을 재생
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying == true) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      // 유저가 bottom sheet 를 해제하면 resolved 될 것이기 떄문에 await 사용
      context: context,
      // bottom sheet 의 사이즈 컨트롤이 가능해짐(ListView 안에서 쓴다면 무조건 true 를 추천함)
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 부모의 색깔을 받아오도록 함(Scaffold)
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChange,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.teal,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  // _animationController 가 이 Builder 를 컨트롤 함
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child, // 아래에 정의한 child 를 호출
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size56,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "@아이디",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Gaps.v10,
                Text(
                  "This is my dogs mozzi & moca",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.white,
                  ),
                ),
                // TODO 해쉬태그 & See more
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/15343250?v=4"),
                  child: Text(
                    "아이디",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: "2.9M",
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: "33K",
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "share",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
