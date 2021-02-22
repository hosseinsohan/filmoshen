import 'package:filimo/src/blocs/showAllMusicAndSearch/bloc.dart';
import 'package:filimo/src/models/music/AudioCategoriesList.dart';
import 'package:filimo/src/models/music/Music.dart';
import 'package:filimo/src/models/music/musicLink/MusicLinkModel.dart';
import 'package:filimo/src/models/showAllMusic/ShowAllMusic.dart' as model;
import 'package:filimo/src/resources/api/audio_api.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/audioRepository.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/ui/page/video_details.dart';
import 'package:filimo/src/ui/widget/detail/videoPlayer.dart';
import 'package:filimo/src/ui/widget/music/audio_category.dart';
import 'package:filimo/src/ui/widget/music/music_player_widget.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

class ShowAllMusic extends StatefulWidget {
  final List<Music> audioDataList;
  final String title;
  final String apiToken;
  final String slug;
  final String type;

  ShowAllMusic(
      {this.audioDataList,
      this.apiToken,
      this.title,
      this.type,
      this.slug,
      Key key})
      : super(key: key);
  @override
  _ShowAllMusicState createState() => _ShowAllMusicState();
}

class _ShowAllMusicState extends State<ShowAllMusic> {
  AudioRepository audioRepository =
      AudioRepository(audioApi: AudioApi(httpClient: http.Client()));
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: widget.type == "search"
            ? null
            : AppBar(
                title: Text(
                  widget.title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
        body: ListView(
          children: <Widget>[
            widget.type == 'album'?
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 10.0),
              child: BlocProvider(
                create: (_) =>
                ShowAllMusicBloc(audioRepository: audioRepository)
                  ..add(GetShowAllMusicAlbumEvent(token: widget.slug)),
                child: BlocBuilder<ShowAllMusicBloc, ShowAllMusicState>(
                  builder: (context, state) {
                    if (state is ErrorShowAllMusicState) {
                      return _errorWidget();
                    } else if (state is LoadedShowAllCategoryMusicState) {
                      return showCategoryDetailsData(state.showAllMusic);
                    } else if (state is EmptyShowAllMusicState) {
                      return Center(
                        child: Text(
                          "اطلاعاتی یافت نشد!",
                        ),
                      );
                    }
                    return _loadingWidget();
                  },
                ),
              ),
            )
            :widget.type != "search"
                ? /*Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10.0),
                    child: GridList(widget.audioDataList, widget.apiToken),
                  )*/

                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(top: 10.0),
                    child: BlocProvider(
                      create: (_) =>
                          ShowAllMusicBloc(audioRepository: audioRepository)
                            ..add(GetShowAllMusicEvent(slug: widget.slug)),
                      child: BlocBuilder<ShowAllMusicBloc, ShowAllMusicState>(
                        builder: (context, state) {
                          if (state is ErrorShowAllMusicState) {
                            return _errorWidget();
                          } else if (state is LoadedShowAllCategoryMusicState) {
                            return showCategoryDetailsData(state.showAllMusic);
                          } else if (state is EmptyShowAllMusicState) {
                            return Center(
                              child: Text(
                                "اطلاعاتی یافت نشد!",
                              ),
                            );
                          }
                          return _loadingWidget();
                        },
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(top: 10.0),
                    child: BlocProvider(
                      create: (_) =>
                          ShowAllMusicBloc(audioRepository: audioRepository)
                            ..add(GetMusicSearchEvent(text: widget.slug)),
                      child: BlocBuilder<ShowAllMusicBloc, ShowAllMusicState>(
                        builder: (context, state) {
                          if (state is ErrorShowAllMusicState) {
                            return _errorWidget();
                          } else if (state is LoadedShowAllMusicState) {
                            return GridList(state.musics, widget.apiToken);
                          } else if (state is EmptyShowAllMusicState) {
                            return Center(
                              child: Text(
                                "اطلاعاتی یافت نشد!",
                              ),
                            );
                          }
                          return _loadingWidget();
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _errorWidget() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(30),
      child: IconButton(
        icon: Icon(
          Icons.refresh,
          size: 50,
        ),
        onPressed: () {
          _update(context);
        },
      ),
    ));
  }

  void _update(BuildContext context) {
    BlocProvider.of<ShowAllMusicBloc>(context)
        .add(GetMusicSearchEvent(text: widget.slug));
  }

  Widget showCategoryDetailsData(model.ShowAllMusic showAllMusic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: GridList(showAllMusic.musics, widget.apiToken),
    ); /*ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        /*Column(
          children: <Widget>[
            /*SliderList(
                        key: PageStorageKey("sliderKey2"),
                      ),*/
            Container(
              child: Column(
                children: showAllMusic.categories.map((category) {
                  return AudioCategoryListWidget(
                    index: 1,
                    audioCategory: category,
                    apiToken: widget.apiToken,
                  );
                }).toList(),
              ),
            ),

            /* SliderList(
                        key: PageStorageKey("sliderKey3"),
                      ),*/
          ],
        ),*/


SizedBox(height: 100,)
      ],
    );*/
  }
}

class GridList extends StatefulWidget {
  final List<Music> audioDataList;
  final String apiToken;

  GridList(this.audioDataList, this.apiToken);

  @override
  _GridListState createState() => _GridListState();
}

class _GridListState extends State<GridList> {
  @override
  Widget build(BuildContext context) {
    var page = MediaQuery.of(context).size;
    var _width = page.width / 3.2;
    var _height = page.width / 3.2;
    var _totalHeight = _height + 50.0;
    return GridView.builder(
      itemCount: widget.audioDataList.length,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: 100),
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: (_width / _totalHeight),
      ),
      shrinkWrap: true,
      itemBuilder: (_, int index) {
        return InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: _width,
                  height: _height,
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
                            image: '$baseUrl${widget.audioDataList[index].cover}',
                            width: _width,
                            height: _width,
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
              ),
              Container(
                width: _width,
                padding: EdgeInsets.all(5),
                child: Text(
                  widget.audioDataList[index].title,
                ),
              ),
            ],
          ),
          onTap: () {


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
