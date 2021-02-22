import 'package:filimo/src/models/movieDetails/Comment.dart';
import 'package:filimo/src/models/sendLikeModel/SendLikeModel.dart';
import 'package:filimo/src/resources/api/genres_api.dart';
import 'package:filimo/src/resources/api/user_api.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/resources/repository/user_repository.dart';
import 'package:filimo/src/ui/widget/avatar_image.dart';
import 'package:filimo/src/ui/widget/detail/commnt_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentList extends StatefulWidget {
  final List<Comment> comments;
  final bool isCommendPage;
  final String apiToken;
  CommentList({this.comments, this.isCommendPage, this.apiToken});

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.comments.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: widget.isCommendPage
            ? BouncingScrollPhysics()
            : NeverScrollableScrollPhysics(),
        itemBuilder: (_, int index) {
          return CommentItem(
            comment: widget.comments[index],
            isCommendPage: widget.isCommendPage,
            isEndItem: index == (widget.comments.length - 1) ? true : false,
            apiToken: widget.apiToken,
          );
        });
  }
}

class CommentItem extends StatefulWidget {
  final Comment comment;
  final bool isCommendPage;
  final bool isEndItem;
  final String apiToken;

  CommentItem(
      {this.comment, this.isCommendPage, this.isEndItem, this.apiToken});

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isLikeLoading;
  bool isDisLikeLoading;
  int likeCount;
  int disLikeCount;
  int authUserHasLiked;

  final GenresRepository genresRepository =
      GenresRepository(genresApi: GenresApi(httpClient: http.Client()));

  final UserRepository userRepository =
      UserRepository(userApi: UserApi(httpClient: http.Client()));

  @override
  void initState() {
    isLikeLoading = false;
    isDisLikeLoading = false;
    likeCount = widget.comment.likeCount;
    disLikeCount = widget.comment.dislikeCount;
    authUserHasLiked = widget.comment.auth_user_has_liked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 20, horizontal: widget.isCommendPage ? 15 : 0),
      margin: EdgeInsets.symmetric(horizontal: widget.isCommendPage ? 0 : 15),
      decoration: widget.isEndItem
          ? BoxDecoration()
          : BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              prifileImage(context),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.comment.user_name,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Theme.of(context).textTheme.title.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.comment.created_at,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.comment.comment,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 13),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                likeCount.toString(),
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              isLikeLoading
                  ? CircularProgressIndicator()
                  : InkWell(
                      child: Icon(
                        Icons.thumb_up,
                        color: authUserHasLiked == 1
                            ? Colors.green.withOpacity(0.4)
                            : Colors.grey[400],
                      ),
                      onTap: () async {
                        if (widget.apiToken == null) {
                          notLoginDialog(
                              content: "برای لایک کامنت باید وارد شوید",
                              title: "وارد شوید",
                              context: context);
                        } else {
                          setState(() {
                            isLikeLoading = true;
                          });
                          String token = await userRepository.getToken();
                          var data = await genresRepository.sendLike(
                              token, widget.comment.id, "like");
                          data == null
                              ? setState(() {
                                  isLikeLoading = false;
                                })
                              : setState(() {
                                  likeCount = data.comment.likeCount;
                                  disLikeCount = data.comment.dislikeCount;
                                  authUserHasLiked = data.like_status;
                                  isLikeLoading = false;
                                });
                        }
                      },
                    ),
              SizedBox(
                width: 10,
              ),
              Text(
                disLikeCount.toString(),
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              isDisLikeLoading
                  ? CircularProgressIndicator()
                  : InkWell(
                      child: Icon(
                        Icons.thumb_down,
                        color: authUserHasLiked == -1
                            ? Colors.red.withOpacity(0.4)
                            : Colors.grey[400],
                      ),
                      onTap: () async {
                        if (widget.apiToken == null) {
                          notLoginDialog(
                              content: "برای دیلایک کامنت باید وارد شوید",
                              title: "وارد شوید",
                              context: context);
                        } else {
                          setState(() {
                            isDisLikeLoading = true;
                          });
                          String token = await userRepository.getToken();
                          var data = await genresRepository.sendLike(
                              token, widget.comment.id, "dislike");
                          data == null
                              ? setState(() {
                                  isDisLikeLoading = false;
                                  print("نشد");
                                })
                              : setState(() {
                                  likeCount = data.comment.likeCount;
                                  disLikeCount = data.comment.dislikeCount;
                                  authUserHasLiked = data.like_status;
                                  isDisLikeLoading = false;
                                });
                        }
                      },
                    )
            ],
          ),
        ],
      ),
    );
  }
}
