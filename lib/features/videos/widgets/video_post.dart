import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:flutter_tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:flutter_tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  const VideoPost({
    Key? key,
    required this.onVideoFinished,
    required this.index,
  }) : super(key: key);

  final Function onVideoFinished;
  final int index;

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin: 위젯이 화면에 보일 때만(current tree) Ticker(시계)를 제공하는데, 이 시계는 매 프레임마다 Animation을 실행시키기 위함
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/sample_video.MOV");

  bool _isPaused = false;
  final Duration _animationDuration = const Duration(milliseconds: 150);

  late final AnimationController _animationController;

  bool _isMuted = true;

  // bool _autoMute = videoConfig.autoMute;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    // WEB 에서 실행될 떄 '음성' 이 있는 영상은 자동재생 되지 않도록 브라우저가 막고 있음(광고 오남용 등 이슈로)
    // k 를 입력하면 Flutter 가 가지고 있는 많은 Contants 들을 사용할 수 있음
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }
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

    // AnimatedBuilder 가 아닌 Listener 를 이용해서 값의 변경을 전파받음
    // videoConfig.addListener(() {
    //   setState(() {
    //     _autoMute = videoConfig.autoMute;
    //   });
    // });
    _initMuted();
  }

  void _onVisibilityChange(VisibilityInfo info) {
    if (!mounted) return; // Bug Fix: 위젯이 Mounted 되지 않았다면 이후 과정이 실행되지 않도록
    // final autoplay = context.read<PlaybackConfigViewModel>().autoplay;
    final autoplay = ref.read(playbackConfigProvider).autoplay;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      if (autoplay) {
        _videoPlayerController.play();
      }
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

  void _onTapVolume() {
    if (_videoPlayerController.value.volume == 0) {
      setState(() {
        _isMuted = false;
        _videoPlayerController.setVolume(20);
      });
    } else {
      setState(() {
        _isMuted = true;
        _videoPlayerController.setVolume(0);
      });
    }
  }

  void _initMuted() {
    // 최초 Init 때 한번만 읽어옴
    // final isAutoMuted = context.read<PlaybackConfigViewModel>().muted;
    final isAutoMuted = ref.read(playbackConfigProvider).muted;
    _setVolumeMuted(isAutoMuted); // 그거에 맞게 볼륨을 맞추고
    setState(() {
      // 변수 반영
      _isMuted = isAutoMuted;
    });
  }

  void _setVolumeMuted(bool isAutoMuted) => isAutoMuted
      ? _videoPlayerController.setVolume(0)
      : _videoPlayerController.setVolume(1);

  void _toggleMuted() {
    _setVolumeMuted(!_isMuted);
    setState(() {
      _isMuted = !_isMuted;
    });
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
            left: 20,
            top: 40,
            child: IconButton(
              icon: FaIcon(
                _isMuted
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: _toggleMuted,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _onTapVolume,
                  child: FaIcon(
                    _isMuted
                        ? FontAwesomeIcons.volumeOff
                        : FontAwesomeIcons.volumeHigh,
                    color: Colors.white,
                  ),
                ),
                Gaps.v24,
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
