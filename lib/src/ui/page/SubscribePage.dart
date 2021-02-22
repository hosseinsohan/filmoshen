import 'package:filimo/src/App.dart';
import 'package:filimo/src/blocs/SubscribeList/bloc.dart';
import 'package:filimo/src/blocs/login/Authentication/bloc.dart';
import 'package:filimo/src/models/SubscribeList/SubscribeListModel.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/api/user_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/resources/repository/user_repository.dart';
import 'package:filimo/src/ui/widget/detail/commnt_widget.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SubscribePage extends StatefulWidget {
  final String apiToken;
  SubscribePage({this.apiToken});
  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  GenresRepository genresRepository =
      new GenresRepository(genresApi: GenresApi(httpClient: http.Client()));
  UserRepository userRepository =
      new UserRepository(userApi: UserApi(httpClient: http.Client()));
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text("خرید اشتراک"),
          ),
          body: BlocProvider(
            create: (_) => SubscribeListBloc(genresRepository: genresRepository)
              ..add(GetSubscribeListEvent()),
            child: BlocBuilder<SubscribeListBloc, SubscribeListState>(
              builder: (context, state) {
                if (state is ErrorSubscribeListState) {
                  return _errorWidget();
                } else if (state is LoadedSubscribeListState) {
                  return showData(state.subscribeListModel);
                }
                return _loadingWidget();
              },
            ),
          )),
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
    BlocProvider.of<SubscribeListBloc>(context).add(GetSubscribeListEvent());
  }

  Widget showData(SubscribeListModel subscribeListModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: subscribeListModel.subscribe
          .map((subscribe) => InkWell(
                onTap: () async {
                  if (widget.apiToken == null) {
                    notLoginDialog(
                        title: "لطفا وارد شوید",
                        content: "برای خرید اشتراک باید وارد شوید",
                        context: context);
                  } else {
                    String url =
                        '$baseUrl/app/payment/get/${subscribe.id}?api_token=${widget.apiToken}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'نمیتونه اجراش کنه';
                    }
                  }
                },
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Theme.of(context).brightness == Brightness.light
                          ? Color(0xFFF2F2F2)
                          : bgColor,
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.network(
                            '$baseUrl${subscribe.icon}',
                            height: 50,
                            color: yellowColor,
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child: const CircularProgressIndicator()),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "اشتراک ${subscribe.monthCount} ماهه",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '${subscribe.price} تومان',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.arrow_forward_ios,
                                    color: Colors.green),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ))
          .toList(),
    );
  }
}
