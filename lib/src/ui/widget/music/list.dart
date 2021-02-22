import 'dart:io';

import 'package:filimo/src/resources/api/audio_api.dart';
import 'package:filimo/src/resources/database/flute_music_player.dart';
import 'package:filimo/src/resources/repository/audioRepository.dart';
import 'package:filimo/src/ui/widget/music/music_player_widget.dart';
import 'package:filimo/src/ui/widget/myFilm/film_gallery.dart';
import 'package:filimo/src/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  AudioRepository audioRepository =
      AudioRepository(audioApi: AudioApi(httpClient: http.Client()));

  String duration;
  String position;
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<FileSystemEntity>>(
            future: audioRepository
                .listofFiles(), // a previously-obtained Future<String> or null
            builder: (BuildContext context,
                AsyncSnapshot<List<FileSystemEntity>> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.length == 0
                    ? GalleryFilm(
                        text:
                            "میتونی آهنگ هایی که دانلود کردی را اینجا پخش کنی",
                      )
                    : ListView.builder(
                        itemCount: snapshot.data.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          String fileName =
                              snapshot.data[index].path.split('/').last;
                          return new Column(
                            children: <Widget>[
                              new Divider(
                                height: 8.0,
                              ),
                              new ListTile(
                                leading: new Hero(
                                  tag: snapshot.data[index].path
                                      .replaceAll(".mp3", ""),
                                  child: avatar(
                                    context,
                                    getImage(
                                      Song.ss(
                                          id: 123456,
                                          title: snapshot.data[index].path
                                              .replaceAll(".mp3", ""),
                                          albumArt: snapshot.data[index].path
                                              .replaceAll(".mp3", ".jpg")),
                                    ),
                                    snapshot.data[index].path
                                        .replaceAll(".mp3", ""),
                                  ),
                                ),
                                title: new Text(fileName.replaceAll(".mp3", ""),
                                    maxLines: 1,
                                    style: new TextStyle(fontSize: 18.0)),
//                          subtitle: new Text(
//                            '${duration ?? ""}',
//                            maxLines: 1,
//                            style: new TextStyle(
//                                fontSize: 12.0, color: Colors.grey),
//                          ),
                                trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (_) =>
                                              new CupertinoAlertDialog(
                                                title: new Text(
                                                  'حذف آهنگ',
                                                ),
                                                content: new Text(
                                                    "آیا می خواهید آهنگ ${fileName.replaceAll(".mp3", "")} را حذف کنید؟"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text(
                                                      'بله',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context, 1);
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text(
                                                      'بعدا',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, null);
                                                    },
                                                  )
                                                ],
                                              )).then((value) async {
                                        if (value != null) {
                                          await File(snapshot.data[index].path
                                                  .replaceAll(".mp3", ".jpg"))
                                              .delete();
                                          await File(snapshot.data[index].path)
                                              .delete();
                                          setState(() {});
                                        }
                                      });
                                    }),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => MusicPlayerWidget(
                                                isFile: true,
                                                file: snapshot.data[index],
                                                image: snapshot.data[index].path
                                                    .replaceAll(".mp3", ".jpg"),
                                              )));
                                },
                                onLongPress: () {},
                              ),
                            ],
                          );
                        },
                      );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error"),
                );
              } else {
                return Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    width: 20,
                    height: 20,
                  ),
                );
              }
            }));
  }
}
