import 'package:filimo/src/models/category/Movie.dart';

class Res {
  //List<Crew> crews;
  List<Movie> movies;
  //List<Object> musics;

  Res({
    this.movies,
  });

  factory Res.fromJson(Map<String, dynamic> json) {
    return Res(
      movies: json['movies'] != null
          ? (json['movies'] as List).map((i) => Movie.fromJson(i)).toList()
          : null,
    );
  }
}
