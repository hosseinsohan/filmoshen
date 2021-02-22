import 'package:filimo/src/blocs/audioBloc/bloc.dart';
import 'package:filimo/src/models/music/Data.dart';
import 'package:filimo/src/resources/api/audio_api.dart';
import 'package:filimo/src/resources/repository/audioRepository.dart';
import 'package:filimo/src/ui/widget/music/audio_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class MusicHomeScreen extends StatefulWidget {
  final String apiToken;
  MusicHomeScreen({this.apiToken, Key key}) : super(key: key);

  @override
  _MusicHomeScreenState createState() => _MusicHomeScreenState();
}

class _MusicHomeScreenState extends State<MusicHomeScreen> {
  AudioRepository audioRepository =
      new AudioRepository(audioApi: AudioApi(httpClient: http.Client()));

  final _scrollController = ScrollController();

  List<Data> preViewlist;

  @override
  void initState() {
    preViewlist = new List<Data>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: widget.key,
      create: (_) => new AudioBloc(audioRepository: audioRepository)
        ..add(AppStartedEvent()),
      child: BlocBuilder<AudioBloc, AudioState>(
        builder: (context, state) {
          if (state is InitialAudioState) {
            // _update(context);
            return _loadingWidget();
          } else if (state is ErrorAudioState) {
            print("EEEEEEEEEroooooooooor");
            return _errorWidget(context);
          } else if (state is LoadedAudioState) {
            print("okkkkkkkkkkkkkkk");
            return _loaded(state.audioCategoriesList, context);
          }
          return _loadingWidget();
        },
      ),
    );
  }

  /*_update(BuildContext contextt) {
    BlocProvider.of<AudioBloc>(contextt).add(GetAudioListEvent());
  }*/

  Widget _errorWidget(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(30),
      child: IconButton(
        icon: Icon(
          Icons.refresh,
          size: 50,
        ),
        onPressed: () {
          BlocProvider.of<AudioBloc>(context).add(AppStartedEvent());
        },
      ),
    ));
  }

  Widget _loadingWidget() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _loaded(
    List<Data> list,
    BuildContext context,
  ) {
    var appBarHeight = kToolbarHeight + 25.0;
    var page = MediaQuery.of(context).size;
    return /*RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          preViewlist = new List<Data>();
          context.bloc<AudioBloc>().add(RefreshCategoryEvent());
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
                            ? topWidget()
                            : AudioCategoryListWidget(
                                audioCategory: list[index - 1],
                                apiToken: widget.apiToken,
                                key: PageStorageKey(list[index - 1].title +
                                    list[index - 1].id.toString()),
                              );
                      },
                    ),
                  )),
            ));
  }

  bool _onScrollNotification(
      ScrollNotification notif, List<Data> list, BuildContext context) {
    if (notif is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      if (preViewlist.length == list.length) {
      } else {
        preViewlist = list;
        context.bloc<AudioBloc>().add(LoadMoreCategoryEvent(categories: list));
      }
    }
    return false;
  }

  /*
  ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: audioCategoriesList.length + 1,
                itemBuilder: (_, int index) {
                  return index == 0
                      ? topWidget()
                      : AudioCategoryListWidget(
                          audioCategoriesList: audioCategoriesList[index - 1],
                          key: PageStorageKey(
                              audioCategoriesList[index - 1].title +
                                  audioCategoriesList[index - 1].id.toString()),
                        );
                },
              )
   */

  Widget topWidget() {
    return Container(
      height: 50,
      /*child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "این قسمت شامل تبلیغات می باشد",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "این قسمت شامل تبلیغات می باشد",
            style: TextStyle(color: Colors.orange),
          ),
          //Image.asset("assets/icon/app_icon.png", width: 50,)
        ],
      ),*/
    );
  }
}
