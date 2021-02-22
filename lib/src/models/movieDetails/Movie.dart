import 'package:filimo/src/models/movieDetails/Age.dart';
import 'package:filimo/src/models/movieDetails/Session.dart';

class Movie {
  String about;
  Age age;
  String cover;
  int id;
  String imdb_id;
  String imdb_score;
  String link;
  String main_title;
  String poster;
  List<Session> sessions;
  String story;
  String time;
  String title;
  String token;
  String type;
  int likeCount;
  int dislikeCount;
  int authUserHasLiked;

  Movie(
      {this.about,
      this.age,
      this.cover,
      this.id,
      this.imdb_id,
      this.imdb_score,
      this.link,
      this.main_title,
      this.poster,
      this.sessions,
      this.story,
      this.time,
      this.title,
      this.token,
      this.type,
      this.authUserHasLiked,
      this.dislikeCount,
      this.likeCount});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      about: json['about'],
      age: json['age'] != null ? Age.fromJson(json['age']) : null,
      cover: json['cover'],
      id: json['id'],
      imdb_id: json['imdb_id'],
      imdb_score: json['imdb_score'],
      link: json['link'] != null ? json['link'] : null,
      main_title: json['main_title'],
      poster: json['poster'],
      sessions: json['sessions'] != null
          ? (json['sessions'] as List).map((i) => Session.fromJson(i)).toList()
          : null,
      story: json['story'],
      time: json['time'],
      title: json['title'],
      token: json['token'],
      type: json['type'],
      likeCount: json['likeCount'],
      dislikeCount: json['dislikeCount'],
      authUserHasLiked: json['auth_user_has_liked'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about'] = this.about;
    data['cover'] = this.cover;
    data['id'] = this.id;
    data['imdb_id'] = this.imdb_id;
    data['imdb_score'] = this.imdb_score;
    data['main_title'] = this.main_title;
    data['poster'] = this.poster;
    data['story'] = this.story;
    data['time'] = this.time;
    data['title'] = this.title;
    data['token'] = this.token;
    data['type'] = this.type;
    if (this.age != null) {
      data['age'] = this.age.toJson();
    }
    if (this.link != null) {
      data['link'] = this.link;
    }
    if (this.sessions != null) {
      data['sessions'] = this.sessions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
