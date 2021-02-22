import 'package:filimo/src/models/categoryList/CategoryList.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryListState {}

//class InitialCategoryListState extends CategoryListState {}

class EmptyCategoryListState extends CategoryListState {}

class ErrorCategoryListState extends CategoryListState {}

class LoadingCategoryListState extends CategoryListState {}

class LoadedCategoryListState extends CategoryListState {
  final CategoryList categories;
  LoadedCategoryListState({this.categories});
}
