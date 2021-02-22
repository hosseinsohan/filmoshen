import 'dart:async';

import 'package:filimo/src/App.dart';
import 'package:filimo/src/blocs/login/Authentication/authentication_bloc.dart';
import 'package:filimo/src/blocs/login/Authentication/bloc.dart';
import 'package:filimo/src/blocs/theme/bloc/theme_bloc.dart';
import 'package:filimo/src/resources/api/user_api.dart';
import 'package:filimo/src/resources/repository/user_repository.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart' as UniLink;
import 'package:flutter/services.dart' show PlatformException;

void main() {
  checkDeepLink();
  UserRepository userRepository =
      new UserRepository(userApi: UserApi(httpClient: http.Client()));

  runApp(BlocProvider(
    create: (_) => ThemeBloc(),
    child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.themeData,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: BlocProvider(
            create: (context) =>
                AuthenticationBloc(userRepository: userRepository),
            child: SplashScreen(),
          ));
    }),
  ));

  /**/
}

Future checkDeepLink() async {
  UserRepository userRepository =
      new UserRepository(userApi: UserApi(httpClient: http.Client()));
  StreamSubscription sub;
  try {
    print("checkDeepLink");
    await UniLink.getInitialLink();
    String token = await userRepository.getToken();
    sub = UniLink.getUriLinksStream().listen((Uri uri) {
      print(uri);
      runApp(BlocProvider(
        create: (_) => AuthenticationBloc(userRepository: userRepository),
        child: StartAppPage(
          token: token,
        ),
      ));
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed

      print("onError");
    });
  } on PlatformException {
    print("PlatformException");
  }
}

bool firstRun;
_checkFirstRun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool firstRun = (prefs.getBool('firstRun') ?? true);

  await prefs.setBool('firstRun', firstRun);
}

/*
class ChackPage extends StatefulWidget {
  @override
  _ChackPageState createState() => _ChackPageState();
}

class _ChackPageState extends State<ChackPage> {
  Widget currentPage;

  @override
  void initState() {
    super.initState();
    firstRun = _checkFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return firstRun ? AppIntro() : SplashScreen();
  }
}
*/
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') return child;

    return new FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class _SplashScreenState extends State<SplashScreen> {
  String token;
  UserRepository userRepository =
      new UserRepository(userApi: UserApi(httpClient: http.Client()));

  navigationPage() {
    Navigator.pushReplacement(
        context,
        new MyCustomRoute(
            builder: (context) => BlocProvider(
                  create: (_) =>
                      AuthenticationBloc(userRepository: userRepository),
                  child: StartAppPage(
                    token: token,
                  ),
                )));
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    var page = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: <Widget>[
          Container(
            height: page.height * 0.8,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(90),
                child: new Image.asset(
                  'assets/icon/app_icon.png',
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationUninitialized) {
                  print("شروع");
                  _update();
                } else if (state is AuthenticationAuthenticated) {
                  print("لاگین کرده");
                  token = state.token;

                  startTime();
                  return _loadingWidget();
                } else if (state is AuthenticationUnauthenticated) {
                  print("لاگین نکرده");
                  startTime();
                  return _loadingWidget();
                }
                return _loadingWidget();
              },
            ),
          ),
        ],
      ),
    );

    /*return Scaffold(

      body:
    );*/
  }

  _update() {
    BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
  }

  Widget _errorWidget() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(30),
      child: IconButton(
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
          size: 50,
        ),
        onPressed: () {
          _update();
        },
      ),
    ));
  }

  Widget _loadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
