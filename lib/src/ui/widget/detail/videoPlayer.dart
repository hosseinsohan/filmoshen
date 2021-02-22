import 'package:filimo/src/utils/flutter_simple_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final String movieUrl;
  final String apiToken;
  final String token;
  VideoPlayer(this.apiToken, {this.movieUrl, this.token, Key key});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: SimpleViewPlayer(
        widget.movieUrl,
        isFullScreen: true,
        token: widget.token,
        apiToken: widget.apiToken,
      ),
    );
  }
}
