import 'package:filimo/src/models/category/Movie.dart';
import 'package:filimo/src/models/movieDetails/Episode.dart';

class Session {
  List<Movie> episodes;
  int id;
  int number;
  String title;

  Session({this.episodes, this.id, this.number, this.title});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      episodes: json['episodes'] != null
          ? (json['episodes'] as List).map((i) => Movie.fromJson(i)).toList()
          : null,
      id: json['id'],
      number: json['number'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['title'] = this.title;
    if (this.episodes != null) {
      data['episodes'] = this.episodes.map((v) => v).toList();
    }
    return data;
  }
}
