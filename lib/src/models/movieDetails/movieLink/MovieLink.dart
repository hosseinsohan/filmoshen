import 'package:filimo/src/models/movieDetails/movieLink/Data.dart';

class MovieLink {
  Data data;

  MovieLink({this.data});

  factory MovieLink.fromJson(Map<String, dynamic> json) {
    return MovieLink(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}
