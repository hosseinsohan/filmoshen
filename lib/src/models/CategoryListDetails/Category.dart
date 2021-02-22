import 'package:filimo/src/models/category/Movie.dart';

class Category {
  int id;
  List<Movie> movies;
  String slug;
  String title;
  String token;

  Category({this.id, this.movies, this.slug, this.title, this.token});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      movies: json['movies'] != null
          ? (json['movies'] as List).map((i) => Movie.fromJson(i)).toList()
          : null,
      slug: json['slug'],
      title: json['title'],
      token: json['token'],
    );
  }
}
