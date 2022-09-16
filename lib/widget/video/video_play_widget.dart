import 'package:chewie/chewie.dart';
import 'package:eyepetizer_flutter/widget/video/video_controls_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayWidget extends StatefulWidget {
  const VideoPlayWidget(
      {Key? key,
      required this.url,
      this.autoPlay = true,
      this.looping = true,
      this.allowFullScreen = true,
      this.allowPlaybackSpeedChanging = true,
      this.aspectRatio = 16 / 9})
      : super(key: key);

  final String url;
  final bool autoPlay;
  final bool looping;
  final bool allowFullScreen;
  final bool allowPlaybackSpeedChanging;
  final double aspectRatio;

  @override
  State<VideoPlayWidget> createState() => VideoPlayWidgetState();
}

class VideoPlayWidgetState extends State<VideoPlayWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.url);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      allowFullScreen: widget.allowFullScreen,
      allowPlaybackSpeedChanging: widget.allowPlaybackSpeedChanging,
      aspectRatio: widget.aspectRatio,
      customControls: VideoControlsWidget(overlayUI: _videoPlayTopBar(), bottomGradient: _blackLinearGradient()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = width / widget.aspectRatio;
    return Container(
      width: width,
      height: height,
      child: Chewie(controller: _chewieController),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void play() {
    _chewieController.play();
  }
  void pause() {
    _chewieController.pause();
  }

  /// 播放视频的 TopBar
  Widget _videoPlayTopBar() {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(right: 8),
        // 渐变背景色
        decoration: BoxDecoration(gradient: _blackLinearGradient(fromTop: true)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(color: Colors.white,),
            Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  /// 渐变背景色
  _blackLinearGradient({bool fromTop = false}) {
    return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ],
    );
  }
}
