import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:filimo/src/models/music/Music.dart';
import 'package:filimo/src/models/music/musicLink/MusicLinkModel.dart';
import 'package:filimo/src/resources/api/audio_api.dart';
import 'package:filimo/src/resources/repository/audioRepository.dart';
import 'package:filimo/src/ui/page/CommentListPage.dart';
import 'package:filimo/src/ui/widget/music/seek_bar.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

const Color backgroundColor = Color(0xffE7E8E8);
const Color dotColor = Color(0xff040602);
/*String albumArtUrl =
    "https://dl.music-ava.ir/music/12/Sasy%20-%20Doctor%20%28%20Dj%20Rasha%20Remix%20%29.mp3?_=4";*/

class MusicPlayerWidget extends StatefulWidget {
  final Music audioData;
  final String apiToken;
  final MusicLinkModel musicLinkModel;
  final bool isFile;
  final File file;
  final String image;
  MusicPlayerWidget(
      {this.audioData,
      this.apiToken,
      this.musicLinkModel,
      this.isFile = false,
      this.image,
      this.file});

  @override
  _MusicPlayerWidgetState createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  //player
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  double height, width, seekBarValue;

  AudioRepository audioRepository =
      AudioRepository(audioApi: AudioApi(httpClient: http.Client()));

  Future<String> getLink() async {
    var details = await audioRepository.fetchMusicLink(widget.audioData.link);
    return details.data.audioUrl;
  }

  bool downloadLoading;
  double _percentage;
  @override
  void initState() {
    downloadLoading = false;
    //print(widget.apiToken);
    seekBarValue = 0.0;
    // _controller.
    _controller = widget.isFile
        ? VideoPlayerController.file(widget.file)
        : VideoPlayerController.network(widget.musicLinkModel.data.audioUrl)
      ..addListener(() {
        if (_controller.value.position == _controller.value.duration) {
          _controller.seekTo(Duration(milliseconds: 0))
            ..then((_) {
              _controller.pause();
            });
          setState(() {
            _controller = this._controller;
          });
        }
      });
    //_controller.setLooping(true);
    //_controller.initialize();

    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    _percentage = 0.0;

    super.dispose();
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.musicLinkModel.data.convert_info.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
                'دانلود با کیفیت ${widget.musicLinkModel.data.convert_info[index].audio_bitrate}'),
            onTap: () {
              Navigator.pop(context, index);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xffDFEAFE)
                              : bgColor,
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xffECF5FC)
                              : bgColor
                        ])),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              widget.isFile
                                  ? Container()
                                  : InkWell(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: AlertDialog(
                                                  title: Text(
                                                    'کیفیت پخش',
                                                    style: TextStyle(
                                                        color: yellowColor),
                                                  ),
                                                  content:
                                                      setupAlertDialoadContainer(),
                                                ),
                                              );
                                            }).then((value) async {
                                          if (value != null) {
                                            setState(() {
                                              downloadLoading = true;
                                            });
                                            var dir =
                                                await getExternalStorageDirectory();
                                            print(dir.toString());
                                            Dio dio = Dio();

                                            dio.download(
                                              '$baseUrl${widget.audioData.cover}',
                                              '${dir.path}/${widget.audioData.title}.jpg',
                                            );
                                            dio.download(
                                                widget.musicLinkModel.data
                                                    .mp4_audios[value],
                                                '${dir.path}/${widget.audioData.title}.mp3',
                                                onReceiveProgress:
                                                    (received, total) {
                                              print((received / total * 100)
                                                      .toStringAsFixed(0) +
                                                  "%");
                                              var percentage =
                                                  received / total * 100;
                                              _percentage = percentage / 100;
                                              setState(() {
                                                this._percentage = _percentage;
                                                if (percentage == 100) {
                                                  downloadLoading = false;
                                                }
                                              });
                                            });
                                            /*await audioRepository.downloadFile(
                                      widget.albumArtUrl,
                                      widget.audioData.title);*/

                                          }
                                        });
                                        /* setState(() {
                                          downloadLoading = true;
                                        });
                                        var dir =
                                            await getExternalStorageDirectory();
                                        print(dir.toString());
                                        Dio dio = Dio();

                                        dio.download(widget.albumArtUrl,
                                            '${dir.path}/${widget.audioData.title}.mp3',
                                            onReceiveProgress:
                                                (received, total) {
                                          print((received / total * 100)
                                                  .toStringAsFixed(0) +
                                              "%");
                                          var percentage =
                                              received / total * 100;
                                          _percentage = percentage / 100;
                                          setState(() {});
                                        });
                                        /*await audioRepository.downloadFile(
                                      widget.albumArtUrl,
                                      widget.audioData.title);*/
                                        setState(() {
                                          downloadLoading = false;
                                        });*/
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: downloadLoading
                                              ? CircularProgressIndicator(
                                                  value: _percentage,
                                                )
                                              : Icon(
                                                  Icons.cloud_download,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Color(0xff97A4B7)
                                                      : bgdeepColor,
                                                ),
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Color(0xffE5F1FD)
                                                    : yellowColor,
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Color(0xff97A4B7)
                                                      : bgdeepColor,
                                                  offset: new Offset(8.0, 10.0),
                                                  blurRadius: 25.0),
                                            ]),
                                      ),
                                    ),
                              widget.isFile
                                  ? Container()
                                  : Container(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.insert_comment,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Color(0xff97A4B7)
                                                    : bgdeepColor,
                                          ),
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      CommentListPage(
                                                        apiToken:
                                                            widget.apiToken,
                                                        type: "music",
                                                        dataToken: widget
                                                            .audioData.token,
                                                        id: widget.audioData.id,
                                                      )))),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Color(0xffE5F1FD)
                                              : yellowColor,
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Color(0xff97A4B7)
                                                    : bgdeepColor,
                                                offset: new Offset(8.0, 10.0),
                                                blurRadius: 25.0),
                                          ]),
                                    ),
                              Container(
                                height: 50,
                                width: 50,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Color(0xff97A4B7)
                                          : bgdeepColor,
                                    ),
                                    onPressed: () => Navigator.pop(context)),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Color(0xffE5F1FD)
                                        : yellowColor,
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Color(0xff97A4B7)
                                              : bgdeepColor,
                                          offset: new Offset(8.0, 10.0),
                                          blurRadius: 25.0),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: height - 460,
                          height: height - 460,
                          margin: EdgeInsets.all(25.0),
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Color(0xffE5F1FD)
                                  : bgColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Color(0xff97A4B7)
                                        : bgdeepColor,
                                    offset: new Offset(8.0, 10.0),
                                    blurRadius: 25.0),
                              ]),
                          child: widget.isFile
                              ? Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(File(widget.image)),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              '$baseUrl${widget.audioData.cover}'),
                                          fit: BoxFit.cover)),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: widget.isFile
                              ? Container()
                              : Text(
                                  widget.audioData.title,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Color(0xff97A4B7)
                                        : Colors.grey,
                                  ),
                                ),
                        ),
                        /*Text(
                          "توضیحات",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Color(0xff97A4B7)
                                    : Colors.grey,
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: SliderWidget(_controller),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 70.0,
                                width: 70.0,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.replay_30,
                                      size: 35,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Color(0xff97A4B7)
                                          : bgdeepColor,
                                    ),
                                    onPressed: () {
                                      if (_controller.value.position >
                                          Duration(seconds: 30)) {
                                        _controller.seekTo(Duration(
                                            seconds: _controller
                                                    .value.position.inSeconds -
                                                30));
                                      } else
                                        _controller
                                            .seekTo(Duration(seconds: 0));
                                    }),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Color(0xffE5F1FD)
                                        : yellowColor,
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Color(0xff97A4B7)
                                              : bgdeepColor,
                                          offset: new Offset(8.0, 10.0),
                                          blurRadius: 25.0),
                                    ]),
                              ),
                              Container(
                                height: 70.0,
                                width: 70.0,
                                child: IconButton(
                                  icon: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 35,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : bgdeepColor),
                                  onPressed: () {
                                    setState(() {
                                      // If the video is playing, pause it.
                                      if (_controller.value.isPlaying) {
                                        _controller.pause();
                                      } else {
                                        // If the video is paused, play it.
                                        _controller.play();
                                      }
                                    });
                                  },
                                ),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Color(0xff97B0EA)
                                        : yellowColor,
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Color(0xff97A4B7)
                                              : bgdeepColor,
                                          offset: new Offset(8.0, 10.0),
                                          blurRadius: 25.0),
                                    ]),
                              ),
                              Container(
                                height: 70.0,
                                width: 70.0,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.forward_30,
                                      size: 35,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Color(0xff97A4B7)
                                          : bgdeepColor,
                                    ),
                                    onPressed: () {
                                      if (_controller.value.position <
                                          _controller.value.duration) {
                                        _controller.seekTo(Duration(
                                            seconds: _controller
                                                    .value.position.inSeconds +
                                                30));
                                      } else
                                        _controller.seekTo(Duration(
                                            seconds: _controller
                                                    .value.duration.inSeconds -
                                                3));
                                    }),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Color(0xffE5F1FD)
                                        : yellowColor,
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Color(0xff97A4B7)
                                              : bgdeepColor,
                                          offset: new Offset(8.0, 10.0),
                                          blurRadius: 25.0),
                                    ]),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
