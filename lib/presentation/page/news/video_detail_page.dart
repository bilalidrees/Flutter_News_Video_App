import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoDetailPage extends StatefulWidget {
  final String url;

  const VideoDetailPage({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late final YoutubePlayerController controller;
  Completer<YoutubePlayerController> _controller = Completer();
  late int currentIndex;
  // bool? isMp4;
  // String? video;

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  void initState() {
    controller = YoutubePlayerController(
        params: YoutubePlayerParams(showFullscreenButton: true, mute: true),
        initialVideoId: YoutubePlayerController.convertUrlToId(widget.url)!);
    _controller.complete(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: _controller.isCompleted? YoutubeAppDemo(
        videoUrl: widget.url,
        controller: controller,
      ):Text('compltere'),
    );
  }
}

class YoutubeAppDemo extends StatefulWidget {
  final String videoUrl;
  final YoutubePlayerController controller;

  const YoutubeAppDemo(
      {Key? key, required this.videoUrl, required this.controller})
      : super(key: key);

  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  String? video;

  @override
  void initState() {
    super.initState();
    video = YoutubePlayerController.convertUrlToId(widget.videoUrl)!;
    widget.controller.mute();
    widget.controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      print('Entered Fullscreen');
    };
    widget.controller.onExitFullscreen = () {
      print('Exited Fullscreen');
    };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      controller: widget.controller,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Stack(
                  children: [
                    player,
                    Positioned.fill(
                      child: YoutubeValueBuilder(
                        controller: widget.controller,
                        builder: (context, value) {
                          return AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Material(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      YoutubePlayerController.getThumbnail(
                                        videoId: video!,
                                        quality: ThumbnailQuality.medium,
                                      ),
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            crossFadeState: value.isReady
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.close();
    super.dispose();
  }
}
