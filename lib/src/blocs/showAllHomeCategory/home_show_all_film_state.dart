import 'package:filimo/src/models/CategoryListDetails/CategoryListDetails.dart';
import 'package:filimo/src/models/category/Movie.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeShowAllFilmState {}

class InitialHomeShowAllFilmState extends HomeShowAllFilmState {}

class EmptyHomeShowAllFilmState extends HomeShowAllFilmState {}

class ErrorHomeShowAllFilmState extends HomeShowAllFilmState {}

class LoadingHomeShowAllFilmState extends HomeShowAllFilmState {}

class LoadedHomeShowAllFilmState extends HomeShowAllFilmState {
  final List<Movie> movies;
  LoadedHomeShowAllFilmState({this.movies});
}

class LoadedCategoryListDetailsState extends HomeShowAllFilmState {
  final CategoryListDetails categoryListDetails;
  LoadedCategoryListDetailsState({this.categoryListDetails});
}
