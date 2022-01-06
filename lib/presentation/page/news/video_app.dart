import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';
import 'package:samma_tv/presentation/theme/app_theme.dart';
import 'package:samma_tv/presentation/widget/custom_loader.dart';
import 'package:video_player/video_player.dart';

// class VideoApp extends StatefulWidget {
//   final String url;
//
//   const VideoApp(this.url, {Key? key}) : super(key: key);
//
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }
//
// class _VideoAppState extends State<VideoApp>
//     with WidgetsBindingObserver, SingleTickerProviderStateMixin {
//   late VideoPlayerController _controller;
//   late final AnimationController animationController;
//   final Duration _duration = const Duration(milliseconds: 500);
//
//   @override
//   void initState() {
//     super.initState();
//
//     animationController = AnimationController(vsync: this, duration: _duration)
//       ..addStatusListener((status) {
//         print(status);
//         if (status == AnimationStatus.completed)
//           Future.delayed(Duration(seconds: 5))
//               .then((value) => animationController.reverse());
//       });
//
//     _controller = VideoPlayerController.network(
//         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         _controller.play();
//         animationController.forward();
//         setState(() {
//
//         });
//       });
//     _controller.play();
//     _controller.setLooping(true);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance?.addObserver(this);
//     _controller.dispose();
//     animationController.removeStatusListener((status) {});
//     animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       // Release the player's resources when not in use. We use "stop" so that
//       // if the app resumes later, it will still remember what position to
//       // resume from.
//       _controller.pause();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // return _controller.value.isInitialized
//     //     ? AspectRatio(
//     //         aspectRatio: _controller.value.aspectRatio,
//     //         child: GestureDetector(
//     //           onTap: (){
//     //             animationController.forward();
//     //           },
//     //           child: Stack(
//     //             alignment: Alignment.bottomCenter,
//     //             children: <Widget>[
//     //               VideoPlayer(_controller),
//     //               ClosedCaption(text: null),
//     //               AnimatedBuilder(
//     //                 animation: animationController,
//     //
//     //                 child: Align(
//     //                   alignment: Alignment.center,
//     //                   child: IconButton(
//     //                     onPressed: () {
//     //                       setState(() {
//     //                         _controller.value.isPlaying
//     //                             ? _controller.pause()
//     //                             : _controller.play();
//     //                       });
//     //                     },
//     //                     iconSize: 45,
//     //                     icon: Icon(
//     //                       _controller.value.isPlaying
//     //                           ? Icons.pause
//     //                           : Icons.play_arrow,
//     //                       color: AppColor.whiteColor,
//     //                     ),
//     //                   ),
//     //                 ),
//     //                 builder: (context, child) {
//     //                   return Opacity(opacity: animationController.value,child: child);
//     //                 }
//     //               ),
//     //               VideoProgressIndicator(_controller, allowScrubbing: true),
//     //               // Here you can also add Overlay capacities
//     //             ],
//     //           ),
//     //         ),
//     //       )
//     //     : AspectRatio(aspectRatio: 1.777777777777777, child: CustomLoader());
//     return AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: GestureDetector(
//         onTap: () {
//           animationController.forward();
//         },
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: <Widget>[
//             VideoPlayer(_controller),
//             ClosedCaption(text: null),
//             Center(
//               child: AnimatedBuilder(
//                   animation: animationController,
//                   child: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _controller.value.isPlaying
//                             ? _controller.pause()
//                             : _controller.play();
//                       });
//                     },
//                     iconSize: 45,
//                     icon: Icon(
//                       _controller.value.isPlaying
//                           ? Icons.pause
//                           : Icons.play_arrow,
//                       color: AppColor.whiteColor,
//                     ),
//                   ),
//                   builder: (context, child) {
//                     return Opacity(
//                         opacity: animationController.value, child: child);
//                   }),
//             ),
//             VideoProgressIndicator(
//               _controller,
//               allowScrubbing: false,
//             ),
//             // Here you can also add Overlay capacities
//           ],
//         ),
//       ),
//     );
//   }
// }

class VideoApp extends StatefulWidget {
  final String url;

  const VideoApp(this.url, {Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late final VideoPlayerController _videoPlayerController;
  late final ChewieController _chewieController;
  final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  @override
  void initState() {
    configuration();
    super.initState();
  }

  configuration() async {
    loadingNotifier.value = false;
    _videoPlayerController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
      showControls: true,
    );
    loadingNotifier.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<bool>(valueListenable: loadingNotifier,
          builder: (context, isLoading, child) =>
          isLoading ? Card(
            child: Chewie(
              controller: _chewieController,
            ),
          )
              : CircularProgressIndicator(),

      ),
    );
  }

  @override
  void dispose() {
    print('video_app dispose');
    _videoPlayerController.dispose();
    _chewieController.dispose();
    loadingNotifier.dispose();
    super.dispose();
    print('video_app dispose Two');
  }
}
