import 'package:filimo/src/models/movieDetails/MovieDetails.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MovieDetailsState {}

class InitialMovieDetailsState extends MovieDetailsState {}

class EmptyMovieDetailsState extends MovieDetailsState {}

class ErrorMovieDetailsState extends MovieDetailsState {}

class LoadingMovieDetailsState extends MovieDetailsState {}

class LoadingLikeState extends MovieDetailsState {
  final int id;
  final type;
  LoadingLikeState({this.id, this.type});
}

class LoadedMovieDetailsState extends MovieDetailsState {
  final MovieDetails movieDetails;
  LoadedMovieDetailsState({this.movieDetails});
}
