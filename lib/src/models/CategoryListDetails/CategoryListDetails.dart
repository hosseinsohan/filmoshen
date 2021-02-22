import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/models/category/Movie.dart';

class CategoryListDetails {
  List<Category> categories;
  List<Movie> movies;

  CategoryListDetails({this.categories, this.movies});

  factory CategoryListDetails.fromJson(Map<String, dynamic> json) {
    return CategoryListDetails(
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((i) => Category.fromJson(i))
              .toList()
          : null,
      movies: json['movies'] != null
          ? (json['movies'] as List).map((i) => Movie.fromJson(i)).toList()
          : null,
    );
  }
}
