import 'dart:convert';

import 'package:filimo/src/blocs/login/Authentication/authentication_bloc.dart';
import 'package:filimo/src/blocs/login/Authentication/bloc.dart';
import 'package:filimo/src/resources/api/user_api.dart';
import 'package:filimo/src/resources/repository/user_repository.dart';
import 'package:filimo/src/ui/widget/loadingWidget.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../App.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool validate;
  String mobile;
  String txtError;
  bool loginLoading;
  @override
  void initState() {
    validate = false;
    loginLoading = false;
    super.initState();
  }

  Future<bool> sendNumber(String mobile, String type) async {
    var url = baseUrl + '/api/v1/login/sendCode';
    print(url);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile': mobile,
      }),
    );
    print("شماره $mobile ارسال شد ");
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      if (json.decode(response.body)['status'] == 1) {
        Navigator.of(context).pushReplacement(new ValidationPageRoute(mobile));
      } else {
        if (type == "login") {
          setState(() {
            loginLoading = false;
            txtError =
                "شما قبلا با این شماره ثبت نام نکرده اید. لطفا ثبت نام کنید";
            validate = true;
          });
        } else {
          Navigator.of(context)
              .pushReplacement(new ValidationPageRoute(mobile));
        }
      }
    } else {
      loginLoading = false;
      throw Exception('خطا در برقراری ارتباط');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body:
            /*DoubleBackToCloseApp(
          snackBar: const SnackBar(
            content: Text(
              'لطفا برای خروج دوباره کلیک کنید',
              textAlign: TextAlign.center,
            ),
          ),
          child: */
            Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/icon/app_icon.png")),
              Padding(
                padding:
                    const EdgeInsets.only(right: 30.0, left: 30, top: 30.0),
                child: loginLoading
                    ? buildLoading(yellowColor)
                    /*Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Loading(
                              indicator: BallPulseIndicator(), size: 20.0),
                        )*/
                    : Text(
                        validate
                            ? txtError
                            : "لطفا شماره تلفن خود را وارد کنید",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: validate
                                ? Colors.red
                                : Theme.of(context).brightness ==
                                        Brightness.light
                                    ? bgdeepColor
                                    : Colors.white.withOpacity(0.6),
                            fontSize: validate ? 14 : 16,
                            fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              getInputField(
                hint: "09016718255",
                obscure: false,
                length: 11,
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 25.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Color(0xFF90c866),
                      borderRadius: new BorderRadius.circular(6.0),
//                      border: Border.all(
//                        width: 0.5,
//                        color: mainColor.withOpacity(0.1),
//                      )
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "ورود",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    loginLoading = true;
                  });
                  if (mobile != null) {
                    int len = mobile.length;
                    if (len == 11) {
                      FutureBuilder<bool>(
                        future: sendNumber(mobile,
                            "login"), // a previously-obtained Future<String> or null
                        builder: (_, AsyncSnapshot<bool> snapshot) {
                          return Container();
                        },
                      );
                    } else {
                      setState(() {
                        loginLoading = false;
                        validate = true;
                        txtError =
                            "لطفا شماره تلفن خود را کامل با احتساب صفر وارد کنید";
                      });
                    }
                  } else {
                    setState(() {
                      loginLoading = false;
                      validate = true;
                      txtError = "لطفا شماره تلفن خود را وارد کنید";
                    });
                  }
                },
              ),
              /*InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 25.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topCenter,
                    decoration: new BoxDecoration(
                      color: Color(0xFF90c866).withOpacity(0.7),
                      borderRadius: new BorderRadius.circular(6.0),
//                      border: Border.all(
//                        width: 0.5,
//                        color: mainColor.withOpacity(0.1),
//                      )
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "ثبت نام",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    loginLoading = true;
                  });
                  if (mobile != null) {
                    int len = mobile.length;
                    if (len == 11) {
                      FutureBuilder<bool>(
                        future: sendNumber(mobile,
                            "register"), // a previously-obtained Future<String> or null
                        builder: (_, AsyncSnapshot<bool> snapshot) {
                          return Container();
                        },
                      );
                    } else {
                      setState(() {
                        loginLoading = false;
                        validate = true;
                        txtError =
                            "لطفا شماره تلفن خود را کامل با احتساب صفر وارد کنید";
                      });
                    }
                  } else {
                    setState(() {
                      loginLoading = false;
                      validate = true;
                      txtError = "لطفا شماره تلفن خود را وارد کنید";
                    });
                  }
                },
              )*/
            ],
          ),
        ),
      ),
    );
  }

  Widget getInputField({String hint, bool obscure, int length}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: Container(
        decoration: new BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white54
                : bgColor,
            borderRadius: new BorderRadius.circular(6.0),
            border: Border.all(
              width: 0.5,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : bgdeepColor.withOpacity(0.1),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            maxLines: 1,
            obscureText: obscure,
            keyboardType: TextInputType.number,
            //textAlign: TextAlign.center,
            inputFormatters: [LengthLimitingTextInputFormatter(length)],
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 18.0),
            decoration: new InputDecoration(
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.phone,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
            ),
            onChanged: (value) {
              setState(() {
                validate = false;
                mobile = value;
              });
            },
            //initialValue: "",
          ),
        ),
      ),
    );
  }
}

class ValidationPageRoute extends CupertinoPageRoute {
  final String mobile;
  ValidationPageRoute(this.mobile)
      : super(builder: (BuildContext context) => new ValidationPage(mobile));

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new SlideTransition(
        transformHitTests: false,
        position: new Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: new SlideTransition(
          position: new Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(secondaryAnimation),
          child: new ValidationPage(mobile),
        ));
  }
}

class ValidationPage extends StatefulWidget {
  final String mobile;
  ValidationPage(this.mobile);
  @override
  _ValidationPageState createState() => new _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  final userRepository =
      UserRepository(userApi: UserApi(httpClient: http.Client()));
  bool validate;
  String code;
  String txtError;
  bool loginLoading;
  @override
  void initState() {
    validate = false;
    loginLoading = false;
    super.initState();
  }

  Future<bool> sendCode(String mobile, String code) async {
    var url = baseUrl + '/api/v1/login/checkCode';
    print(url);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile': mobile,
        'loginCode': code,
      }),
    );
    print("شماره $mobile ارسال شد ");
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      if (json.decode(response.body)['status'] == 1) {
//          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(
//              token: json.decode(response.body)['token'], mobile: mobile));
        print(json.decode(response.body).toString());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<AuthenticationBloc>(
                create: (context) {
                  return AuthenticationBloc(userRepository: userRepository)
                    ..add(LoggedIn(
                        mobile: mobile,
                        token: json.decode(response.body)['api_token']));
                },
                child: StartAppPage(
                  token: json.decode(response.body)['api_token'],
                ),
              ),
            ));
      } else {
        setState(() {
          loginLoading = false;
          txtError =
              "لطفا کد ارسال شده به شماره همراهتان را به درستی وارد کنید";
          validate = true;
        });
      }
    } else if (response.statusCode == 422) {
      setState(() {
        loginLoading = false;
        txtError = "لطفا کد ارسال شده به شماره همراهتان را به درستی وارد کنید";
        validate = true;
      });
    } else {
      loginLoading = false;
      throw Exception('خطا در برقراری ارتباط');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: new Scaffold(
        body:
            /*DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text(
                'لطفا برای خروج دوباره کلیک کنید',
                textAlign: TextAlign.center,
              ),
            ),
            child: */
            Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
              Container(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/icon/app_icon.png")),
              Padding(
                padding:
                    const EdgeInsets.only(right: 30.0, left: 30, top: 30.0),
                child: loginLoading
                    ? buildLoading(Colors.white)
                    /*Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Loading(
                                    indicator: BallPulseIndicator(),
                                    size: 20.0),
                              )*/
                    : Text(
                        validate
                            ? txtError
                            : "لطفا کد ارسالی به شماره تلفن خود را وارد کنید",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: validate
                                ? Colors.red
                                : Theme.of(context).brightness ==
                                        Brightness.light
                                    ? bgColor
                                    : Colors.white.withOpacity(0.6),
                            fontSize: validate ? 14 : 16,
                            fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              getInputField(
                hint: "12345",
                obscure: false,
                length: 5,
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 25.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Color(0xFF90c866).withOpacity(0.7),
                      borderRadius: new BorderRadius.circular(6.0),
//                      border: Border.all(
//                        width: 0.5,
//                        color: mainColor.withOpacity(0.1),
//                      )
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "ارسال کد",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    loginLoading = true;
                  });
                  if (code != null) {
                    int len = code.length;
                    if (len == 5) {
                      FutureBuilder<bool>(
                        future: sendCode(widget.mobile,
                            code), // a previously-obtained Future<String> or null
                        builder: (_, AsyncSnapshot<bool> snapshot) {
                          return Container();
                        },
                      );
                    } else {
                      setState(() {
                        loginLoading = false;
                        validate = true;
                        txtError = "لطفا کد را کامل وارد کنید";
                      });
                    }
                  } else {
                    setState(() {
                      loginLoading = false;
                      validate = true;
                      txtError = "لطفا کد را وارد کنید";
                    });
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                child: Text(
                  'شماره تلفن را اشتباه وارد کرده اید؟',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white54.withOpacity(0.6)
                        : Colors.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => LoginPage()));
                },
              )
            ])),
      ),
    );
  }

  Widget getInputField({String hint, bool obscure, int length}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: Container(
        decoration: new BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white54
                : bgColor,
            borderRadius: new BorderRadius.circular(6.0),
            border: Border.all(
              width: 0.5,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            maxLines: 1,
            obscureText: obscure,
            keyboardType: TextInputType.number,
            //textAlign: TextAlign.center,
            inputFormatters: [LengthLimitingTextInputFormatter(length)],
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 18.0),
            decoration: new InputDecoration(
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.lock,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
            ),
            onChanged: (value) {
              setState(() {
                validate = false;
                code = value;
              });
            },
            //initialValue: "",
          ),
        ),
      ),
    );
  }
}
