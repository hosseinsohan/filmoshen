import 'package:filimo/src/models/bookMark/Bookmark.dart';
import 'package:filimo/src/models/bookMark/User.dart';
import 'package:filimo/src/models/category/Movie.dart';

class ShowBookMark {
  List<Movie> bookmarks;
  int status;
  User user;

  ShowBookMark({this.bookmarks, this.status, this.user});

  factory ShowBookMark.fromJson(Map<String, dynamic> json) {
    return ShowBookMark(
      bookmarks: json['bookmarks'] != null
          ? (json['bookmarks'] as List).map((i) => Movie.fromJson(i)).toList()
          : null,
      status: json['status'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
