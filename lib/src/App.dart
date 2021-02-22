import 'dart:io';

import 'package:filimo/src/ui/page/category_screen.dart';
import 'package:filimo/src/ui/page/home_screen.dart';
import 'package:filimo/src/ui/page/music.dart';
import 'package:filimo/src/ui/page/myfilm_screen.dart';
import 'package:filimo/src/ui/page/settingPage.dart';
import 'package:filimo/src/ui/widget/avatar_image.dart';
import 'package:filimo/src/ui/widget/search/custum_search_delegate.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/login/Authentication/bloc.dart';
import 'models/genres/Genres.dart';

class StartAppPage extends StatelessWidget {
  final String token;
  final int initialPage;

  StartAppPage({this.token, this.initialPage});

  BuildContext context;
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'خروج',
              textAlign: TextAlign.right,
            ),
            content: Text(
              'آیا میخواهی از برنامه خارج شوی؟',
              textAlign: TextAlign.right,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('نه'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('بله'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                print(state);
                if (state is AuthenticationUninitialized) {
                  print("initial myApp");
                  return AppPage(
                    token: token,
                    initialPage: initialPage,
                  );
                } else if (state is AuthenticationAuthenticated) {
                  print("Authenticated myApp");
                  return AppPage(
                    token: state.token,
                    initialPage: initialPage,
                  );
                } else if (state is AuthenticationUnauthenticated) {
                  print("Unauthenticated myApp");
                  return AppPage(
                    token: null,
                    initialPage: initialPage,
                  );
                } else if (state is AuthenticationLoading) {
                  print("Loading myApp");
                  print("لودینگ");
                  return LoadingIndicator();
                }
                print("لودینگmyApp");
                return LoadingIndicator();
              },
            )),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(),
      );
}

class AppPage extends StatefulWidget {
  final String token;
  final int initialPage;
  AppPage({this.token, this.initialPage});
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

  final Key keyHome = PageStorageKey('homePage');
  final Key keyCategory = PageStorageKey('categoryPage');
  final Key keyProfile = PageStorageKey('profilePage');
  final Key keyMusic = PageStorageKey('musicPage');

  HomeScreen homeScreen;
  CategoryScreen categoryScreen;
  MyFilmScreen myFilmScreen;
  MusicScreen musicScreen;
  List<Widget> pages;

  Widget currentPage;
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    homeScreen = HomeScreen(
      key: keyHome,
      apiToken: widget.token,
    );
    categoryScreen = CategoryScreen(
      key: keyCategory,
      token: widget.token,
    );
    myFilmScreen = MyFilmScreen(
      key: keyProfile,
      apiToken: widget.token,
    );
    musicScreen = MusicScreen(
      apiToken: widget.token,
    );

    pages = [
      categoryScreen,
      myFilmScreen,
      homeScreen,
      musicScreen,
    ];

    currentPage = homeScreen;
    selectedIndex = widget.initialPage ?? 2;
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      currentPage = pages[index];
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.token);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: kToolbarHeight + 26,
              padding: EdgeInsets.only(top: 25, right: 15, left: 15),
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset("assets/icon/appbar.png"),
                  ),
                  /*Text(
                    "فیلموشن",
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? yellowColor
                            : Theme.of(context).textTheme.title.color,
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700),
                  ),*/
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: prifileImage(context),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AppSetting(
                                      apiToken: widget.token,
                                    ))),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: CustomSearchDelegate(
                                apiToken: widget.token,
                                type: selectedIndex == 3 ? "music" : "movie"),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(child: currentPage),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.format_list_bulleted,
                size: 24.0,
              ),
              title: Text(
                'دسته‌بندی‌فیلم',
                style: optionStyle,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.videocam,
                size: 24.0,
              ),
              title: Text(
                'فیلم های من',
                style: optionStyle,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 24.0,
              ),
              title: Text(
                'ویترین',
                style: optionStyle,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.music_note,
                size: 24.0,
              ),
              title: Text(
                'موزیک',
                style: optionStyle,
              ),
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: selectedIndex,
          selectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? yellowColor
              : Colors.black54,
          unselectedItemColor: tapUnSelecredColor,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? bgColor
              : Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
