import 'package:filimo/src/blocs/comment/bloc.dart';
import 'package:filimo/src/models/movieDetails/Comment.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/ui/widget/avatar_image.dart';
import 'package:filimo/src/ui/widget/detail/comment_list.dart';
import 'package:filimo/src/ui/widget/detail/commnt_widget.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:filimo/src/utils/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CommentListPage extends StatefulWidget {
  final String apiToken;
  final String dataToken;
  final String type;
  final int id;
  CommentListPage({this.apiToken, this.dataToken, this.type, this.id});

  @override
  _CommentListPageState createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {
  String textmessage;
  TextEditingController _controller;
  bool isLoading;

  GenresRepository genresRepository =
      GenresRepository(genresApi: GenresApi(httpClient: http.Client()));

  void callBack() {
    setState(() {
      isLoading = false;
      _controller.text = "";
      _controller.clear();
    });
  }

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "دیدگاه ها",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87),
            ),
          ),
          body: BlocProvider(
            create: (_) =>
                GetAllCommentsBloc(genresRepository: genresRepository)
                  ..add(GetCommentsEvent(
                      apiToken: widget.apiToken,
                      dataToken: widget.dataToken,
                      type: widget.type)),
            child: BlocBuilder<GetAllCommentsBloc, GetAllCommentsState>(
              builder: (context, state) {
                if (state is LoadedGetAllCommentsState) {
                  return showData(state.comments);
                } else if (state is EmptyGetAllCommentsState) {
                  return showData([]);
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

  Widget showData(List<Comment> comments) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: comments.isEmpty
                ? Container(
                    child: Center(
                      child: Text(
                        "برای این آهنگ دیدگاهی ثبت نشده است!\n شما می توانید اولین نفری باشید که برای این آهنگ دیدگاه ارسال می کند",
                        textAlign: TextAlign.center,
                        strutStyle: StrutStyle(height: 2.0),
                      ),
                    ),
                  )
                : CommentList(
                    comments: comments,
                    isCommendPage: true,
                    apiToken: widget.apiToken,
                  ),
          ),
        ),
        _buildMessageComposer(),
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  width: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : Colors.black54))),
      child: Row(
        children: <Widget>[
          prifileImage(context),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        textmessage = value;
                      },
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Theme.of(context).textTheme.title.color,
                        fontSize: 17,
                      ),
                      controller: _controller,
                      decoration: InputDecoration.collapsed(
                          hintText:
                              'دیدگاه خود را درباره فیلم اینجا بنویسید ...',
                          hintStyle: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[400]
                                  : Theme.of(context).textTheme.title.color,
                              fontSize: 12)),
                    ),
                  ),
                  IconButton(
                    icon: isLoading
                        ? CircularProgressIndicator()
                        : Icon(Icons.send),
                    iconSize: 20.0,
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      if (widget.apiToken == null) {
                        notLoginDialog(
                            content: "برای ارسال دیدگاه باید وارد شوید",
                            title: "وارد شوید",
                            context: context);
                      } else {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          isLoading = true;
                        });
                        if (textmessage == "" || textmessage == null) {
                          _showCupertinoDialog(
                              context: context,
                              title: "خطا",
                              content:
                                  "برای ارسال دیدگاه، ابتدا باید دیدگاه مورد نظر خود را وارد کنید ",
                              callBack: this.callBack);
                        } else {
                          var response = await genresRepository.sendComment(
                              widget.apiToken, "music", widget.id, textmessage);
                          response ? textmessage = "" : print("error");
                          response
                              ? _showCupertinoDialog(
                                  context: context,
                                  title: "دیدگاه شما با موفقیت ثبت شد",
                                  content:
                                      "دیدگاه شما پس از تایید توسط کارشناسان ثبت خواهد شد",
                                  callBack: this.callBack)
                              : _showCupertinoDialog(
                                  context: context,
                                  title: "خطا",
                                  content:
                                      "در ارسال دیدگاه شما مشکلی پیش آمده است، لطفا دوباره تلاش کنید",
                                  callBack: this.callBack);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showCupertinoDialog(
      {BuildContext context, String title, String content, Function callBack}) {
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
                    'متوجه شدم',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            )).then((value) => callBack());
  }
}
