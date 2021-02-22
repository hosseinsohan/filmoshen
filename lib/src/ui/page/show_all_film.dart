import 'package:filimo/src/blocs/bookMark/bloc.dart';
import 'package:filimo/src/blocs/showAllHomeCategory/bloc.dart';
import 'package:filimo/src/models/CategoryListDetails/CategoryListDetails.dart';
import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/models/category/Movie.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/ui/page/video_details.dart';
import 'package:filimo/src/ui/widget/home/category_list.dart';
import 'package:filimo/src/ui/widget/home/slider.dart';
import 'package:filimo/src/ui/widget/myFilm/film_gallery.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

class ShowAllFilm extends StatefulWidget {
  final String slug;
  final String categoryTitle;
  final int index;
  final String apiToken;
  ShowAllFilm({this.slug, this.index, this.categoryTitle, this.apiToken});
  @override
  _ShowAllFilmState createState() => _ShowAllFilmState();
}

class _ShowAllFilmState extends State<ShowAllFilm> {
  GenresRepository genresRepository =
      GenresRepository(genresApi: GenresApi(httpClient: http.Client()));
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: widget.index == 2 || widget.index == 5 || widget.index == 12
              ? null
              : AppBar(
                  title: Text(
                    widget.categoryTitle,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
          body: widget.index == 1
              ? BlocProvider(
                  create: (_) =>
                      HomeShowAllFilmBloc(genresRepository: genresRepository)
                        ..add(GetCategoryListDetailsEvent(slug: widget.slug)),
                  child: BlocBuilder<HomeShowAllFilmBloc, HomeShowAllFilmState>(
                    builder: (context, state) {
                      if (state is ErrorHomeShowAllFilmState) {
                        return _errorWidget();
                      } else if (state is LoadedHomeShowAllFilmState) {
                        return showData(state.movies);
                      } else if (state is LoadedCategoryListDetailsState) {
                        return showCategoryDetailsData(
                            state.categoryListDetails);
                      }
                      return _loadingWidget();
                    },
                  ),
                )
              : widget.index == 0
                  ? BlocProvider(
                      create: (_) => HomeShowAllFilmBloc(
                          genresRepository: genresRepository)
                        ..add(GetHomeShowAllFilmEvent(slug: widget.slug)),
                      child: BlocBuilder<HomeShowAllFilmBloc,
                          HomeShowAllFilmState>(
                        builder: (context, state) {
                          if (state is ErrorHomeShowAllFilmState) {
                            return _errorWidget();
                          } else if (state is LoadedHomeShowAllFilmState) {
                            return showData(state.movies);
                          } else if (state is LoadedCategoryListDetailsState) {
                            return showCategoryDetailsData(
                                state.categoryListDetails);
                          }
                          return _loadingWidget();
                        },
                      ),
                    )
                  : widget.index == 5
                      ? BlocProvider(
                          create: (_) => ShowBookMarkBloc(
                              genresRepository: genresRepository)
                            ..add(GetSearchResultEvent(text: widget.slug)),
                          child:
                              BlocBuilder<ShowBookMarkBloc, ShowBookMarkState>(
                            builder: (context, state) {
                              if (state is ErrorShowBookMarkState) {
                                return _errorWidget();
                              } else if (state is LoadedShowSearchResultState) {
                                return showData(state.movies);
                              } else if (state is EmptyShowBookMarkState) {
                                return Center(
                                  child: Text(
                                    "اطلاعاتی یافت نشد!",
                                  ),
                                );
                              }
                              return _loadingWidget();
                            },
                          ),
                        )
                      : widget.index == 12
                          ? BlocProvider(
                              create: (_) => ShowBookMarkBloc(
                                  genresRepository: genresRepository)
                                ..add(
                                    GetViewedEvent(apiToken: widget.apiToken)),
                              child: BlocBuilder<ShowBookMarkBloc,
                                  ShowBookMarkState>(
                                builder: (context, state) {
                                  if (state is ErrorShowBookMarkState) {
                                    return _errorWidget();
                                  } else if (state
                                      is LoadedShowSearchResultState) {
                                    return showData(state.movies);
                                  } else if (state is EmptyShowBookMarkState) {
                                    return GalleryFilm(
                                      text:
                                          "فیلم هایی که قبلا مشاهده کردی رو میتونی اینجا ببینی",
                                    );
                                  }
                                  return _loadingWidget();
                                },
                              ),
                            )
                          : BlocProvider(
                              create: (_) => ShowBookMarkBloc(
                                  genresRepository: genresRepository)
                                ..add(GetBookMarkListEvent(
                                    apiToken: widget.apiToken)),
                              child: BlocBuilder<ShowBookMarkBloc,
                                  ShowBookMarkState>(
                                builder: (context, state) {
                                  if (state is ErrorShowBookMarkState) {
                                    return _errorWidget();
                                  } else if (state is LoadedShowBookMarkState) {
                                    return showData(
                                        state.showBookMark.bookmarks);
                                  } else if (state is EmptyShowBookMarkState) {
                                    return GalleryFilm(
                                      text:
                                          "میتونی فیلم هایی که دوست داری را به علاقه مندی ها اضافه کنی و اینجا ببینی",
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
    BlocProvider.of<HomeShowAllFilmBloc>(context)
        .add(GetHomeShowAllFilmEvent(slug: widget.slug));
  }

  Widget _loadingWidget() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget showData(List<Movie> movies) {
    return ListView(
      children: <Widget>[
        /*widget.index == 1
            ? Column(
                children: <Widget>[
                  /*SliderList(
                        key: PageStorageKey("sliderKey2"),
                      ),*/
                  CategoryList(
                    haveShowAll: true,
                  ),
                  /* SliderList(
                        key: PageStorageKey("sliderKey3"),
                      ),*/
                ],
              )
            : Container(),*/
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 10.0),
          child: GridList(movies, widget.apiToken),
        ),
      ],
    );
  }

  Widget showCategoryDetailsData(CategoryListDetails categoryListDetails) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            /*SliderList(
                        key: PageStorageKey("sliderKey2"),
                      ),*/
            Container(
              child: Column(
                children: categoryListDetails.categories.map((category) {
                  return CategoryList(
                    haveShowAll: true,
                    category: category,
                  );
                }).toList(),
              ),
            )
            /* SliderList(
                        key: PageStorageKey("sliderKey3"),
                      ),*/
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 10.0),
          child: GridList(categoryListDetails.movies, widget.apiToken),
        ),
      ],
    );
  }
}

class GridList extends StatefulWidget {
  final List<Movie> movies;
  final String apiToken;

  GridList(this.movies, this.apiToken);

  @override
  _GridListState createState() => _GridListState();
}

class _GridListState extends State<GridList> {
  @override
  Widget build(BuildContext context) {
    var page = MediaQuery.of(context).size;
    var _width = page.width / 3.2;
    var _height = _width * 4 / 3;
    var _totalHeight = _height + 65.0;
    return GridView.builder(
      itemCount: widget.movies.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: (_width / _totalHeight),
      ),
      shrinkWrap: true,
      itemBuilder: (_, int index) {
        return InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
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
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: '$baseUrl${widget.movies[index].cover}',
                        width: _width,
                        height: _height,
                        fit: BoxFit.cover,
                      )

                      //Image.network(widget.categories.data[index].poster,),
                      ),
                ),
              ),
              Container(
                width: _width,
                padding: EdgeInsets.all(5),
                child: Text(
                  widget.movies[index].title,
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DetailPage(
                        widget.movies[index].token, widget.apiToken)));
          },
        );
      },
    );
  }
}
