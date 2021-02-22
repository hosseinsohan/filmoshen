import 'package:dio/dio.dart';
import 'package:filimo/src/blocs/movieDetails/bloc.dart';
import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/models/movieDetails/Movie.dart';
import 'package:filimo/src/models/movieDetails/MovieDetails.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/api/user_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/resources/repository/user_repository.dart';
import 'package:filimo/src/ui/page/SubscribePage.dart';
import 'package:filimo/src/ui/page/loginPage.dart';
import 'package:filimo/src/ui/page/video_player_screen.dart';
import 'package:filimo/src/ui/widget/detail/app_bar.dart';
import 'package:filimo/src/ui/widget/detail/commnt_widget.dart';
import 'package:filimo/src/ui/widget/detail/film_maker.dart';
import 'package:filimo/src/ui/widget/detail/hideTitle.dart';
import 'package:filimo/src/ui/widget/detail/videoPlayer.dart';
import 'package:filimo/src/ui/widget/home/category_list.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class DetailPage extends StatefulWidget {
  final String token;
  final String apiToken;

  DetailPage(this.token, this.apiToken);

  @override
  State<StatefulWidget> createState() => DetailState();
}

class DetailState extends State<DetailPage> {
  GenresRepository genresRepository =
      new GenresRepository(genresApi: GenresApi(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    print(widget.apiToken);
    return Material(
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocProvider(
            create: (_) => MovieDetailsBloc(genresRepository: genresRepository)
              ..add(GetMovieDetails(
                  token: widget.token, apiToken: widget.apiToken)),
            child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
              builder: (context, state) {
                if (state is ErrorMovieDetailsState) {
                  return _errorWidget();
                } else if (state is LoadedMovieDetailsState) {
                  return ShowData(
                    movieDetails: state.movieDetails,
                    apiToken: widget.apiToken,
                  );
                }
                return _loadingWidget();
              },
            ),
          )),
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
    BlocProvider.of<MovieDetailsBloc>(context)
        .add(GetMovieDetails(token: widget.token));
  }

  Widget _loadingWidget() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ShowData extends StatefulWidget {
  final MovieDetails movieDetails;
  final String apiToken;
  ShowData({this.movieDetails, this.apiToken});
  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  ScrollController _scrollController;
  bool bookMark;
  bool likeLoading;
  bool disLikeLoading;
  int authUserHasLiked;
  int likeCount;
  int dislikeCount;
  GenresRepository genresRepository =
      new GenresRepository(genresApi: GenresApi(httpClient: http.Client()));
  UserRepository userRepository =
      new UserRepository(userApi: UserApi(httpClient: http.Client()));

  double _percentage = 0.0;
  @override
  void initState() {
    _scrollController = ScrollController();
    bookMark = widget.movieDetails.bookmark;
    likeLoading = false;
    disLikeLoading = false;
    authUserHasLiked = widget.movieDetails.movie.authUserHasLiked;
    likeCount = widget.movieDetails.movie.likeCount;
    dislikeCount = widget.movieDetails.movie.dislikeCount;
    //_network.movieVideos(widget._movie.id);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(bookMark);
    DateTime time = DateTime.now();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double marginTop = isPortrait ? 70.0 : 110.0;
    double ratingTop = isPortrait ? 220.0 : 260.0;
    return Container(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          appBar(
            marginTop,
            ratingTop,
            time,
            context,
            widget.movieDetails,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    widget.movieDetails.movie.type != "serial" ||
                            widget.movieDetails.movie.sessions.isEmpty
                        ? Container()
                        : SizedBox(
                            height: 20,
                          ),
                    widget.movieDetails.movie.sessions == null
                        ? Container()
                        : Column(
                            children: widget.movieDetails.movie.sessions
                                .map(
                                  (session) => session.episodes.isNotEmpty
                                      ? CategoryList(
                                          haveShowAll: false,
                                          apiToken: widget.apiToken,
                                          category: Category(
                                              id: 21233,
                                              title: session.title,
                                              token: widget.apiToken,
                                              movies: session.episodes),
                                        )
                                      : Container(),
                                )
                                .toList(),
                          ),
                    widget.movieDetails.movie.type != "serial" ||
                            widget.movieDetails.movie.sessions.isEmpty
                        ? Container()
                        : Divider(
                            height: 0.1,
                            color: Colors.grey,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    FilmMaker(
                      aboutFilm: widget.movieDetails.movie.about,
                      actors: widget.movieDetails.actors,
                      factors: widget.movieDetails.factors,
                      story: widget.movieDetails.movie.story,
                    ),
                    Divider(
                      height: 0.1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CommentWidget(
                      movieDetails: widget.movieDetails,
                      apiToken: widget.apiToken,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget appBar(
    double marginTop,
    double ratingTop,
    DateTime time,
    BuildContext context,
    MovieDetails movieDetails,
  ) {
    return SliverAppBar(
      expandedHeight: 435,
      primary: true,
      floating: false,
      pinned: true,
      title: SABT(
        child: FittedBox(
          child: Text(movieDetails.movie.title,
              style: TextStyle(
                fontSize: 24.0,
              )),
        ),
      ),
      actions: <Widget>[
        SABT(
          child: IconButton(
              icon: bookMark
                  ? Icon(
                      Icons.bookmark,
                      color: Theme.of(context).textTheme.title.color,
                    )
                  : Icon(
                      Icons.bookmark_border,
                      color: Theme.of(context).textTheme.title.color,
                    ),
              onPressed: () async {
                if (widget.apiToken == null) {
                  _showCupertinoDialog(
                      content: "برای افزودن به علاقه مندی ها باید وارد شوید",
                      title: "وارد شوید",
                      context: context);
                } else {
                  bool preBookMark = bookMark;

                  var data = preBookMark
                      ? await genresRepository.removeBookmark(
                          widget.apiToken, movieDetails.movie.token)
                      : await genresRepository.addBookmark(
                          widget.apiToken, movieDetails.movie.token);
                  setState(() {
                    this.bookMark = !preBookMark;
                  });
                  data
                      ? print("Ok")
                      : setState(() {
                          bookMark = preBookMark;
                        });
                }
              }),
        ),
        SABT(
          child: IconButton(
              icon: Icon(
                Icons.share,
                color: Theme.of(context).textTheme.title.color,
              ),
              onPressed: () => Share.share("""
                من فیلم ${movieDetails.movie.title} را به شما پیشنهاد میکنم. میتونی این فیلم رو در لین زیر پیدا کنی \n www.filmoshen.ir
                """)),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
          background: getTopBanner(marginTop, ratingTop, time, context,
              movieDetails.movie, movieDetails.omdbApiKey)),
    );
  }

  Widget getTopBanner(double marginTop, double ratingTop, DateTime time,
      BuildContext context, Movie movie, String imdbApikey) {
    return Container(
      //color: Colors.blue,
      color: Theme.of(context).canvasColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            children: <Widget>[
              getMovieDetailsSection(marginTop, time, movie.poster),
              getMoviePosterAndRatingSection(marginTop, ratingTop, context,
                  movie, widget.apiToken, imdbApikey),
              Positioned(top: 25, left: 0, child: getAppBarIcons(movie)),
            ], // BACK DETAILS > THUMBNAIL POSTER
          ),
          getShowButtonANDLike(context, movie),

        ],
      ),
    );
  }

  Widget getAppBarIcons(Movie movie) {
    return Row(
      children: <Widget>[
        IconButton(
            icon: Icon(
              bookMark ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () async {
              if (widget.apiToken == null) {
                _showCupertinoDialog(
                    content: "برای افزودن به علاقه مندی ها باید وارد شوید",
                    title: "وارد شوید",
                    context: context);
              } else {
                bool preBookMark = bookMark;

                var data = preBookMark
                    ? await genresRepository.removeBookmark(
                        widget.apiToken, movie.token)
                    : await genresRepository.addBookmark(
                        widget.apiToken, movie.token);
                setState(() {
                  this.bookMark = !preBookMark;
                });
                data
                    ? print("Ok")
                    : setState(() {
                        bookMark = preBookMark;
                      });
              }
            }),
        IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () => Share.share("""
                من فیلم ${movie.title} را به شما پیشنهاد میکنم. میتونی این فیلم رو در لین زیر پیدا کنی \n www.filmoshen.ir
                """)),
      ],
    );
  }

  Widget getShowButtonANDLike(BuildContext context, Movie movie) {
    return Column(
      children: <Widget>[
        Container(
          //margin: EdgeInsets.all(20),
          padding: EdgeInsets.only(bottom: 15, top: 15, left: 15, right: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              border:
                  Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  /*ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: RaisedButton(
                        color: yellowColor,
                        child: Container(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.file_download,
                                color: Colors.white,
                              ),
                              Text(
                                "دانلود",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                        onPressed: () async {
                          var dir = await getExternalStorageDirectory();
                          print(dir.toString());
                          Dio dio = Dio();
                          if (widget.apiToken == null) {
                            _showCupertinoDialog(
                                content: "برای دانلود فیلم باید وارد شوید",
                                title: "وارد شوید",
                                context: context);
                          } else {
                            /* getLink(movie.link).then((value) => dio.download(
                                    value, '${dir.path}/${movie.token}.mp4',
                                    onReceiveProgress: (received, total) {
                                  print((received / total * 100)
                                          .toStringAsFixed(0) +
                                      "%");
                                  var percentage = received / total * 100;
                                  _percentage = percentage / 100;
                                  setState(() {});
                                }));*/
                          }
                        }),
                  ),*/
                  SizedBox(width: 20),
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: RaisedButton(
                        color: yellowColor,
                        child: Container(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                              Text(
                                "تماشا",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                        onPressed: () async {
                          if (widget.apiToken == null) {
                            _showCupertinoDialog(
                                content: "برای مشاهده فیلم باید وارد شوید",
                                title: "وارد شوید",
                                context: context);
                          } else if (widget.movieDetails.subscribe_days == 0) {
                            _showSubscribeDialog(
                                content:
                                    "برای مشاهده فیلم باید اشتراک خریداری کنید",
                                title: "اشتراک ندارید!",
                                context: context);
                          } else {
                            getLink(movie.link).then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => VideoPlayer(
                                          widget.apiToken,
                                          movieUrl: value,
                                          key: PageStorageKey("videokey"),
                                          token: movie.token,
                                        )
                                    )));
                            /*VideoPlayerScreen(
                                          widget.apiToken,
                                          movieUrl: value,
                                          key: PageStorageKey("videokey"),
                                          token: movie.token,
                                        )*/
                          }
                        }),
                  ),
                ],
              ),
              _percentage == 0 || _percentage == 1
                  ? Container()
                  : LinearProgressIndicator(
                      value: _percentage,
                    )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 23, top: 20, left: 20, right: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey),
              )),
          child: Row(
            children: <Widget>[
              Expanded(
                  child:
                      /*Text(
              "79% این فیلم را دوست داشتند",
            )*/
                      Container()),
              Container(
                width: 100,
                color: Theme.of(context).canvasColor,
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: likeLoading
                                ? CircularProgressIndicator()
                                : Icon(
                                    Icons.thumb_up,
                                    color: authUserHasLiked == 1
                                        ? Colors.green.withOpacity(0.4)
                                        : Colors.grey,
                                  ),
                          ),
                          onTap: () async {
                            if (widget.apiToken == null) {
                              _showCupertinoDialog(
                                  content: "برای لایک فیلم باید وارد شوید",
                                  title: "وارد شوید",
                                  context: context);
                            } else {
                              setState(() {
                                likeLoading = true;
                              });
                              String token = await userRepository.getToken();
                              var data = await genresRepository.sendMovieLike(
                                  token,
                                  widget.movieDetails.movie.token,
                                  "like");
                              data == null
                                  ? setState(() {
                                      likeLoading = false;
                                    })
                                  : setState(() {
                                      likeCount = data.counts.likeCount;
                                      dislikeCount = data.counts.dislikeCount;
                                      authUserHasLiked = data.like_status;
                                      likeLoading = false;
                                    });
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(likeCount.toString())
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: disLikeLoading
                                ? CircularProgressIndicator()
                                : Icon(
                                    Icons.thumb_down,
                                    color: authUserHasLiked == -1
                                        ? Colors.red.withOpacity(0.4)
                                        : Colors.grey[400],
                                  ),
                          ),
                          onTap: () async {
                            if (widget.apiToken == null) {
                              _showCupertinoDialog(
                                  content: "برای دیسلایک فیلم باید وارد شوید",
                                  title: "وارد شوید",
                                  context: context);
                            } else {
                              setState(() {
                                disLikeLoading = true;
                              });
                              String token = await userRepository.getToken();
                              var data = await genresRepository.sendMovieLike(
                                  token,
                                  widget.movieDetails.movie.token,
                                  "dislike");
                              data == null
                                  ? setState(() {
                                      disLikeLoading = false;
                                    })
                                  : setState(() {
                                      likeCount = data.counts.likeCount;
                                      dislikeCount = data.counts.dislikeCount;
                                      authUserHasLiked = data.like_status;
                                      disLikeLoading = false;
                                    });
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(dislikeCount.toString())
                      ],
                    )
                  ],
                ),

              )
            ],
          ),
        ),

      ],
    );
  }

  Future<String> getLink(String link) async {
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

  _showCupertinoDialog({BuildContext context, String title, String content}) {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text(
                title,
              ),
              content: new Text(content),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'ورود',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => LoginPage()));
                  },
                ),
                FlatButton(
                  child: Text(
                    'بعدا',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  _showSubscribeDialog({BuildContext context, String title, String content}) {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text(
                title,
              ),
              content: new Text(content),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'خرید اشتراک',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SubscribePage(
                              apiToken: widget.apiToken,
                            )));
                  },
                ),
                FlatButton(
                  child: Text(
                    'بعدا',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
