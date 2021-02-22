import 'package:filimo/src/models/movieDetails/MovieDetails.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/ui/page/CommentListPage.dart';
import 'package:filimo/src/ui/page/loginPage.dart';
import 'package:filimo/src/ui/widget/avatar_image.dart';
import 'package:filimo/src/ui/widget/detail/comment_list.dart';
import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentWidget extends StatefulWidget {
  final MovieDetails movieDetails;
  final String apiToken;
  CommentWidget({this.movieDetails, this.apiToken});
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  String textmessage;
  TextEditingController _controller;

  GenresRepository genresRepository =
      GenresRepository(genresApi: GenresApi(httpClient: http.Client()));
  bool isLoading;

  void callBack() {
    setState(() {
      isLoading = false;
      textmessage = "";
      _controller.clear();
    });
  }

  @override
  void initState() {
    isLoading = false;
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: _buildShowAll(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: CommentList(
              comments: widget.movieDetails.comments,
              isCommendPage: false,
              apiToken: widget.apiToken,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: _buildMessageComposer(),
              ))
        ],
      ),
    );
  }

  _buildMessageComposer() {
    return Row(
      children: <Widget>[
        prifileImage(context),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 10),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                    width: 0.5,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey
                        : Colors.grey[900])),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: false,
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
                        hintText: 'دیدگاه خود را درباره فیلم اینجا بنویسید ...',
                        //filled: true,
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[300]
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
                          content: "برای ارسال کامنت باید وارد شوید",
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
                            widget.apiToken,
                            widget.movieDetails.movie_type,
                            widget.movieDetails.movie.id,
                            textmessage);
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
    );
  }

  Widget _buildShowAll() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        widget.movieDetails.comments.isEmpty
            ? Container(
                width: MediaQuery.of(context).size.width - 50,
                alignment: Alignment.center,
                child: Text(
                  'دیدگاهی برای این فیلم وجود ندارد',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              )
            : Row(
                children: <Widget>[
                  Icon(
                    Icons.message,
                    size: 15,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'دیدگاه ها',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
        widget.movieDetails.comments.isEmpty
            ? Container()
            : InkWell(
                child: Row(
                  children: <Widget>[
                    Text(
                      "همه دیدگاه ها",
                      style: TextStyle(
                          color: redColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: redColor,
                      size: 15,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CommentListPage(
                                apiToken: widget.apiToken,
                                type: widget.movieDetails.movie_type,
                                dataToken: widget.movieDetails.movie.token,
                                id: widget.movieDetails.movie.id,
                              )));
                },
              )
      ],
    );
  }
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

notLoginDialog({BuildContext context, String title, String content}) {
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
