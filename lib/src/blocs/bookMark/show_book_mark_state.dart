import 'package:filimo/src/models/bookMark/ShowBookMark.dart';
import 'package:filimo/src/models/category/Movie.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ShowBookMarkState {}

class InitialShowBookMarkState extends ShowBookMarkState {}

class EmptyShowBookMarkState extends ShowBookMarkState {}

class ErrorShowBookMarkState extends ShowBookMarkState {}

class LoadingShowBookMarkState extends ShowBookMarkState {}

class LoadedShowBookMarkState extends ShowBookMarkState {
  final ShowBookMark showBookMark;
  LoadedShowBookMarkState({this.showBookMark});
}

class LoadedShowSearchResultState extends ShowBookMarkState {
  final List<Movie> movies;
  LoadedShowSearchResultState({this.movies});
}
