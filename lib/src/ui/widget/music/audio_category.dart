import 'package:filimo/src/models/music/AudioCategoriesList.dart';
import 'package:filimo/src/models/music/Data.dart';
import 'package:filimo/src/models/music/Music.dart';
import 'package:filimo/src/models/music/musicLink/MusicLinkModel.dart';
import 'package:filimo/src/resources/api/audio_api.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/audioRepository.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/ui/page/show_all_music.dart';
import 'package:filimo/src/models/showAllMusic/ShowAllMusic.dart' as model;
import 'package:filimo/src/ui/widget/detail/videoPlayer.dart';
import 'package:filimo/src/ui/widget/music/music_player_widget.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

class AudioCategoryListWidget extends StatefulWidget {
  final Data audioCategory;
  final String apiToken;
  final int index;

  AudioCategoryListWidget(
      {this.apiToken, this.audioCategory, this.index = 0, Key key})
      : super(key: key);

  @override
  _AudioCategoryListWidgetState createState() =>
      _AudioCategoryListWidgetState();
}

class _AudioCategoryListWidgetState extends State<AudioCategoryListWidget> {
  @override
  Widget build(BuildContext context) {
    return _loadedWidget(audioCategory: widget.audioCategory);
  }

  Widget _loadedWidget({Data audioCategory}) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                audioCategory.title??"",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              Row(
                children: <Widget>[
                  Material(
                      child: InkWell(
                          child: Text(
                            "مشاهده همه",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 17),
                          ),
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShowAllMusic(
                                    apiToken: widget.apiToken,
                                    audioDataList: audioCategory.musics,
                                    title: audioCategory.title,
                                    slug: audioCategory.slug,
                                  ),
                                ),
                              ))),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.red,
                    size: 15,
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          margin: EdgeInsets.only(top: 10.0),
          child: ItemLoad(
            audioDataList: audioCategory.musics,
            apiToken: widget.apiToken,
          ),
        )
      ],
    );
  }
}

class ItemLoad extends StatefulWidget {
  final List<Music> audioDataList;
  final String apiToken;

  ItemLoad({this.audioDataList, this.apiToken});

  @override
  _ItemLoadState createState() => _ItemLoadState();
}

class _ItemLoadState extends State<ItemLoad> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.audioDataList.length,
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: index == 0 ? 10 : 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  '$baseUrl${widget.audioDataList[index].cover}',
                              width: 150,
                              height: 225,
                              fit: BoxFit.cover,
                            )

                            //Image.network(widget.categories.data[index].poster,),
                            ),
                        Positioned(
                            bottom: 10,
                            right: 10,
                            child: widget.audioDataList[index].type ==
                                    'music_video'
                                ? Icon(Icons.videocam)
                                :widget.audioDataList[index].type == 'album'
                            ?Icon(Icons.add_to_photos_sharp)
                            :Container())
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      widget.audioDataList[index].title,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          onTap: () async {
            /*FutureBuilder<String>(
              future: getLink(widget.audioDataList[index].link) ,// a previously-obtained Future<String> or null
              builder: (_,
                  AsyncSnapshot<String> snapshot) {
                return Container();
              },
            );*/
            if (widget.audioDataList[index].type == 'single') {
              getLink(widget.audioDataList[index].link)
                  .then((value) => value == null
                      ? print("musicccc nulll")
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MusicPlayerWidget(
                                    audioData: widget.audioDataList[index],
                                    apiToken: widget.apiToken,
                                    musicLinkModel: value,
                                  ))));
            } else if (widget.audioDataList[index].type == 'album') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShowAllMusic(
                    apiToken: widget.apiToken,
                    title: 'آلبوم ${widget.audioDataList[index].title}',
                    slug: widget.audioDataList[index].token,
                    type: 'album',
                  ),
                ),
              );
            } else if (widget.audioDataList[index].type == 'music_video') {
              getMovieLink(widget.audioDataList[index].link)
                  .then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => VideoPlayer(
                                widget.apiToken,
                                movieUrl: value,
                                key: PageStorageKey("videokey"),
                              ))));
            }
          },
        );
      },
    );
  }

  Future<MusicLinkModel> getLink(String link) async {
    AudioRepository audioRepository =
        AudioRepository(audioApi: AudioApi(httpClient: http.Client()));
    var details = await audioRepository.fetchMusicLink(link);
    return details;
  }

  Future<String> getMovieLink(String link) async {
    GenresRepository genresRepository =
        GenresRepository(genresApi: GenresApi(httpClient: http.Client()));
    try {
      var details = await genresRepository.fetchMovieLink(link);
      return details.data.video_url;
    } catch (e) {
      print("لینک فایل خراب است");
      throw e;
    }
  }
}
