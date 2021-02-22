import 'Movie.dart';

class Category {
  int id;
  List<Movie> movies;
  String title;
  String token;
  String slug;

  Category({this.id, this.movies, this.title, this.token, this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      movies: json['movies'] != null
          ? (json['movies'] as List).map((i) => Movie.fromJson(i)).toList()
          : null,
      title: json['title'],
      token: json['token'],
      slug: json['slug'],
    );
  }
}
