import 'package:filimo/src/models/category/Category.dart';

class FilmHomeCategories {
  List<Category> categories;

  FilmHomeCategories({this.categories});

  factory FilmHomeCategories.fromJson(Map<String, dynamic> json) {
    return FilmHomeCategories(
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((i) => Category.fromJson(i))
              .toList()
          : null,
    );
  }
}
