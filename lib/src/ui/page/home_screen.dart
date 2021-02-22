import 'package:carousel_slider/carousel_slider.dart';
import 'package:filimo/src/blocs/category/bloc.dart';
import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/models/category/Movie.dart';
import 'package:filimo/src/models/slider/SliderModel.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/ui/page/video_details.dart';
import 'package:filimo/src/ui/widget/home/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String apiToken;
  HomeScreen({Key key, this.apiToken}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GenresRepository genresRepository =
      new GenresRepository(genresApi: GenresApi(httpClient: http.Client()));

  final _scrollController = ScrollController();

  List<Category> preViewlist;

  @override
  void initState() {
    preViewlist = new List<Category>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.apiToken);
    return BlocProvider(
      key: widget.key,
      create: (_) => new CategoryBloc(genresRepository: genresRepository)
        ..add(AppStartedEvent()),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          /*if (state is InitialCategoryState) {
            _update(context);
            return _loadingWidget();
          }  else */
          if (state is ErrorCategoryState) {
            return _errorWidget();
          } else if (state is LoadedCategoryState) {
            return _loaded(state.categories, context);
          } else if (state is LoadingCategoryState) {
            _loadingWidget(preViewlist, context);
          }
          return _loadingWidget(preViewlist, context);
        },
      ),
    );
  }

  /* _update(BuildContext context) {
    BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
  }*/

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
          BlocProvider.of<CategoryBloc>(context).add(AppStartedEvent());
        },
      ),
    ));
  }

  Widget _loadingWidget(List<Category> list, BuildContext context) {
    return list.isEmpty
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        : Stack(
            children: <Widget>[
              _loaded(list, context),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 100,
                    child: Container(
                        width: 20,
                        height: 20,
                        child: FittedBox(
                            child: CircularProgressIndicator(
                          strokeWidth: 2,
                        )))),
              )
            ],
          );
  }

  Widget _loaded(
    List<Category> list,
    BuildContext context,
  ) {
    var appBarHeight = kToolbarHeight + 25.0;
    var page = MediaQuery.of(context).size;
    return /*RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          preViewlist = new List<Category>();
          context.bloc<CategoryBloc>().add(RefreshCategoryEvent());
        },
        child: */
        Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Container(
                  height: page.height - appBarHeight,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) =>
                        _onScrollNotification(notification, list, context),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      padding: EdgeInsets.all(0),
                      itemCount: list.length + 1,
                      itemBuilder: (_, int index) {
                        return index == 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: topWidget(key: PageStorageKey("slider")),
                              )
                            : CategoryList(
                                category: list[index - 1],
                                haveShowAll: true,
                                apiToken: widget.apiToken,
                                key: PageStorageKey(list[index - 1].token),
                              );
                      },
                    ),
                  )),
            ));
  }

  bool _onScrollNotification(
      ScrollNotification notif, List<Category> list, BuildContext context) {
    if (notif is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      if (preViewlist.length == list.length) {
      } else {
        preViewlist = list;
        context
            .bloc<CategoryBloc>()
            .add(LoadMoreCategoryEvent(categories: list));
      }
    }
    return false;
  }

  Widget topWidget({Key key}) {
    return FutureBuilder<SliderModel>(
      future: genresRepository
          .fetchSlider(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<SliderModel> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          return CarouselSlider(
            key: key,
            options: CarouselOptions(
              aspectRatio: 2.0,
              autoPlayCurve: Curves.easeInOutExpo,
              initialPage: 0,
              viewportFraction: 0.9,
              autoPlay: false,
            ),
            items: snapshot.data.sliders.map((movie) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    child: Stack(
                      children: <Widget>[
                    Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8),),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  '$baseUrl${movie.image}',
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                movie.name_image==null?'':'$baseUrl${movie.name_image}',
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              )),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetailPage(
                                  movie.movie_token, widget.apiToken)));
                    },
                  );
                },
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          children = <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.red,
                size: 60,
              ),
              onPressed: () {
                setState(() {});
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 20,
              height: 20,
            ),
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
    /*return */
  }
}
