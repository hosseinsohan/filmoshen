import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/models/category/FilmHomeCategories.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryState {}

class EmptyCategoryState extends CategoryState {}

class ErrorCategoryState extends CategoryState {}

class LoadingCategoryState extends CategoryState {}

class MoreLoadingCategoryState extends CategoryState {}

class LoadedCategoryState extends CategoryState {
  final List<Category> categories;
  LoadedCategoryState({this.categories});
}
