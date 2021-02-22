import 'package:chewie/chewie.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';


class VideoPlayerScreen extends StatefulWidget {
  final String movieUrl;
  final String apiToken;
  final String token;
  VideoPlayerScreen(this.apiToken, {this.movieUrl, this.token, Key key})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  double _aspectRatio = 16 / 9;

  bool isSendedView;

  GenresRepository genresRepository =
      GenresRepository(genresApi: GenresApi(httpClient: http.Client()));
  @override
  initState() {
    super.initState();
    isSendedView = false;
    //'https://web2020.arvanvod.com/1v959pd7ex/2Rrq4dqYPv/origin_Baqnhjorp1fYVnw0z38AX2FsR69Bjlk0sjzuITtv.mp4'
    print(widget.movieUrl);
    _videoPlayerController = VideoPlayerController.network(
      widget.movieUrl,
    );
    _chewieController = ChewieController(
      //allowedScreenSleep: false,
      //allowFullScreen: true,
      fullScreenByDefault: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
      videoPlayerController: _videoPlayerController,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: true,
      showControls: true,
      materialProgressColors: new ChewieProgressColors(
        playedColor: yellowColor,
        handleColor: yellowColor,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.black.withOpacity(0.3),
      ),
    );

    _chewieController.videoPlayerController.addListener(() {
      if (_chewieController.videoPlayerController.value.position >
          _chewieController.videoPlayerController.value.duration * .7) {
        if (!isSendedView) {
          genresRepository.sendViewed(widget.apiToken, widget.token);
          sendView();
        }
      }
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void sendView() {
    setState(() {
      isSendedView = true;
    });
  }

  void disposecontroller() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
  }

  @override
  void dispose() {
    disposecontroller();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Chewie(
          key: Key(_chewieController.videoPlayerController.dataSource),
          controller: _chewieController,
        ),
      ],
    ));
  }
}
