import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class SingletonVideoPlayer extends StatefulWidget {
  //传入视频url
  final String videoUrl;

  const SingletonVideoPlayer({super.key, required this.videoUrl});

  @override
  State<SingletonVideoPlayer> createState() => _SingletonVideoPlayerState();
}

class _SingletonVideoPlayerState extends State<SingletonVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  bool get wantKeepAlive => true; // 保持widget活跃状态

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      optionsTranslation: null,
      autoPlay: false,
      looping: false,
      //配置视频宽高比
      aspectRatio: 3 / 2,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 保持widget活跃状态
    return Chewie(
      controller: _chewieController,
    );
  }
}
