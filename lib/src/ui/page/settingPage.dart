import 'package:filimo/src/App.dart';
import 'package:filimo/src/blocs/login/Authentication/bloc.dart';
import 'package:filimo/src/blocs/theme/bloc/theme_bloc.dart';
import 'package:filimo/src/models/bookMark/User.dart';
import 'package:filimo/src/resources/api/user_api.dart';
import 'package:filimo/src/resources/repository/user_repository.dart';
import 'package:filimo/src/ui/page/SubscribePage.dart';
import 'package:filimo/src/ui/page/aboutPage.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:filimo/src/utils/global/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'loginPage.dart';

class AppSetting extends StatefulWidget {
  final String apiToken;
  AppSetting({this.apiToken});
  @override
  _AppSettingState createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  bool _isDarkTheme;
  UserRepository userRepository =
      UserRepository(userApi: UserApi(httpClient: http.Client()));

  bool isLoading;
  String subscribeTxt;
  @override
  void initState() {
    isLoading = true;
    userRepository.fetchSubscribeDays(widget.apiToken).then((value) {
      setState(() {
        isLoading = false;
        value != null
            ? subscribeTxt = value
            : subscribeTxt = "مشکل در دریافت اطلاعات";
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var page = MediaQuery.of(context).size;
    _isDarkTheme =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              width: page.width,
              height: 25,
              color: Theme.of(context).brightness == Brightness.dark
                  ? bgdeepColor
                  : yellowColor,
            ),
            SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/icon/app_icon.png',
              height: page.height * 0.3,
            ),
            SizedBox(
              height: 20,
            ),
            widget.apiToken != null
                ? Container()
                : RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginPage()));
                    },
                    color: yellowColor,
                    textColor: Colors.white,
                    child: Text(
                      'ورود و ثبت نام'.toUpperCase(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            line,
            ListTile(
              title: Text('خرید اشتراک'),
              leading: Icon(Icons.donut_small),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SubscribePage(
                              apiToken: widget.apiToken,
                            )));
              },
            ),
            widget.apiToken == null ? Container() : line,
            widget.apiToken == null
                ? Container()
                : ListTile(
                    title: Text(isLoading
                        ? 'دریافت اطلاعات . . .'
                        : subscribeTxt == "0"
                            ? "شما هنوز اشتراک ندارید!"
                            : "اشتراک : $subscribeTxt روز"),
                    leading: Icon(Icons.description),
                    trailing: Icon(Icons.chevron_right),
                  ),
            line,
            SwitchListTile(
              title: Text('تم تیره'),
              secondary: Icon(Icons.brightness_3),
              value: _isDarkTheme,
              onChanged: (isDarkTheme) {
                isDarkTheme
                    ? BlocProvider.of<ThemeBloc>(context)
                        .add(ThemeChanged(theme: AppTheme.Dark))
                    : BlocProvider.of<ThemeBloc>(context)
                        .add(ThemeChanged(theme: AppTheme.Light));
              },
              activeColor: yellowColor,
            ),
            line,
            ListTile(
              title: Text('درباره'),
              leading: Icon(Icons.error),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AboutPage())),
            ),
            line,
            widget.apiToken == null
                ? Container()
                : ListTile(
                    title: Text('خروج'),
                    leading: Icon(Icons.exit_to_app),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () async {
                      await userRepository.persistToken("", "").then((value) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                      create: (_) => AuthenticationBloc(
                                          userRepository: userRepository),
                                      child: StartAppPage(
                                        token: null,
                                      )))));
                    },
                  ),
          ],
        ),
      )),
    );
  }

  var line = Divider(
    height: 0.5,
    color: Colors.grey,
  );
}

/*
child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("رنگ سفید", style: TextStyle(color: Colors.white),),
              onPressed: () => BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.Light))
              ),
              RaisedButton(
              child: Text("رنگ سیاه", style: TextStyle(color: Colors.white),),
              onPressed: () => BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.Dark))
              ),
              Text("رنگ", style: Theme.of(context).textTheme.title,)
          ],
        ),
      ),
*/
