import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constant/gaps.dart';
import 'package:flutter_tiktok_clone/constant/sizes.dart';
import 'package:flutter_tiktok_clone/features/videos/views/video_preview_screen.dart';
import 'package:flutter_tiktok_clone/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoRecodingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload-video";

  const VideoRecodingScreen({Key? key}) : super(key: key);

  @override
  State<VideoRecodingScreen> createState() => _VideoRecodingScreenState();
}

class _VideoRecodingScreenState extends State<VideoRecodingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // SingleTickerProviderStateMixin 을 주로 썻었는데, 여기서는 Animation 을 2개 이상 다룰꺼기 때문에..
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  bool _isFlashMode = false;
  bool _isFlashLightMode = false;

  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late CameraController _cameraController;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
  );

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 10,
    ),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.5).animate(_buttonAnimationController);

  Future<void> initPermissions() async {
    final cameraPermissionStatus = await Permission.camera.request();
    final microphonePermissionStatus = await Permission.microphone.request();

    final cameraDenied = cameraPermissionStatus.isDenied ||
        cameraPermissionStatus.isPermanentlyDenied;
    final microphoneDenied = microphonePermissionStatus.isDenied ||
        microphonePermissionStatus.isPermanentlyDenied;

    if (!cameraDenied && !microphoneDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      // 권한이 거부당했을 때 메시지를 보여주고, 다시 화면에 진입하면 물어봐야하나?
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    ); // 0: 후면 카메라, 1: 전면 카메라

    await _cameraController.initialize();
    await _cameraController.prepareForVideoRecording(); // only - iOS
  }

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    // Mixin 에 WidgetBindingObserver 추가 후 사용 가능
    WidgetsBinding.instance.addObserver(this);
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 애니메이션의 상태를 추적하는 리스너
        _stopRecoding();
      }
    });
  }

  Future<void> toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
  }

  Future<void> toggleFlashMode() async {
    if (_cameraController.value.flashMode != FlashMode.off) {
      await _cameraController.setFlashMode(FlashMode.off);
      _isFlashMode = false;
    } else {
      await _cameraController.setFlashMode(FlashMode.always);
      _isFlashMode = true;
    }
    setState(() {});
  }

  Future<void> toggleFlashLight() async {
    if (_cameraController.value.flashMode != FlashMode.torch) {
      await _cameraController.setFlashMode(FlashMode.torch);
      _isFlashLightMode = true;
    } else {
      await _cameraController.setFlashMode(FlashMode.off);
      _isFlashLightMode = false;
    }
    setState(() {});
  }

  Future<void> _startRecoding(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecoding() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final videoFile = await _cameraController.stopVideoRecording();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: videoFile,
          isPicked: false,
        ),
      ),
    );

    // print(videoFile.name);
    // print(videoFile.path);
    /*
    flutter: REC_E2BFA938-9E21-4055-BD61-33DDA3E4D411.mp4
    flutter: /var/mobile/Containers/Data/Application/EDEFC5CF-BC3F-491F-A2A5-4F7821E85266/Documents/camera/videos/REC_E2BFA938-9E21-4055-BD61-33DDA3E4D411.mp4
    */
  }

  Future<void> _onPickVideoPressed() async {
    final pickVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickVideo == null) return;

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: pickVideo,
          isPicked: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    if (!_noCamera) _cameraController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  // 카메라 라이브러리에서 AppLifeCycle 을 관리해줄 수 없기 때문에 직접 관리해주는 메서드를 작성해야함
  // WidgetBindingObserver 를 추가하고 난 뒤에 활용 가능
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      await initCamera();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = isDarkMode(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: !_hasPermission
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Initializing Cameras....",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                      ),
                    ),
                    Gaps.v20,
                    CircularProgressIndicator.adaptive(),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_noCamera && _cameraController.value.isInitialized)
                      CameraPreview(_cameraController),
                    Positioned(
                      top: Sizes.size20,
                      left: Sizes.size20,
                      child: CloseButton(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    // Positioned 는 Stack 내에서 child 를 독립적으로 이동시키는 방법
                    if (!_noCamera)
                      Positioned(
                        top: Sizes.size48,
                        right: Sizes.size10,
                        child: Column(
                          children: [
                            IconButton(
                              color: Colors.white,
                              onPressed: toggleSelfieMode,
                              icon: const Icon(
                                Icons.cameraswitch,
                              ),
                            ),
                            Gaps.v10,
                            IconButton(
                              color: _isFlashMode
                                  ? Colors.amber.shade200
                                  : Colors.white,
                              onPressed: toggleFlashMode,
                              icon: Icon(_isFlashMode
                                  ? Icons.flash_on_rounded
                                  : Icons.flash_off_rounded),
                            ),
                            Gaps.v10,
                            IconButton(
                              color: _isFlashLightMode
                                  ? Colors.amber.shade200
                                  : Colors.white,
                              onPressed: toggleFlashLight,
                              icon: Icon(_isFlashLightMode
                                  ? Icons.flashlight_on
                                  : Icons.flashlight_off),
                            ),
                          ],
                        ),
                      ),
                    Positioned(
                      bottom: Sizes.size40,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onPanUpdate: (DragUpdateDetails details) =>
                                {}, // TODO 드래그하고 위로 올리거나 내리면 Zoom-In / Zoom-out 되게끔
                            onTapDown: _startRecoding,
                            onTapUp: (details) => _stopRecoding(),
                            child: ScaleTransition(
                              scale: _buttonAnimation,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: Sizes.size80 + Sizes.size14,
                                    height: Sizes.size80 + Sizes.size14,
                                    child: CircularProgressIndicator(
                                      color: Colors.red.shade400,
                                      strokeWidth: Sizes.size6,
                                      value: _progressAnimationController.value,
                                    ),
                                  ),
                                  Container(
                                    width: Sizes.size80,
                                    height: Sizes.size80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: _onPickVideoPressed,
                                icon: FaIcon(
                                  FontAwesomeIcons.image,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
