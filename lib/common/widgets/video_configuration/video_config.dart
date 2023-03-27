// Provider 를 사용함
// class VideoConfig extends ChangeNotifier {
//   bool isMuted = false;
//   bool isAutoplay = false;
//
//   void toggleIsMuted() {
//     isMuted = !isMuted;
//     notifyListeners();
//   }
//
//   void toggleAutoplay() {
//     isAutoplay = !isAutoplay;
//     notifyListeners();
//   }
// }

// Value 한개만 드러내는 ValueChangeNotifier 를 사용할 수도 있음(거의 없을듯^^)
// class VideoConfig extends ChangeNotifier {
//   bool autoMute = false;
//
//   void toggleMute() {
//     autoMute = !autoMute;
//     notifyListeners();
//   }
// }
//
// final videoConfig = VideoConfig();

// class VideoConfigData extends InheritedWidget {
//   const VideoConfigData({
//     super.key,
//     required super.child,
//     required this.autoMute,
//     required this.toggleMuted,
//   });
//
//   final bool autoMute;
//   final void Function() toggleMuted;
//
//   static VideoConfigData of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
//   }
//
//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return true;
//   }
// }
//
// class VideoConfig extends StatefulWidget {
//   final Widget child;
//
//   const VideoConfig({Key? key, required this.child}) : super(key: key);
//
//   @override
//   State<VideoConfig> createState() => _VideoConfigState();
// }
//
// class _VideoConfigState extends State<VideoConfig> {
//   bool autoMute = true;
//
//   void toggleMuted() {
//     setState(() {
//       autoMute = !autoMute;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return VideoConfigData(
//       autoMute: autoMute,
//       toggleMuted: toggleMuted,
//       child: widget.child,
//     );
//   }
// }
