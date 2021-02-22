import 'package:filimo/src/models/movieDetails/MovieDetails.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MovieDetailsEvent {}

class GetMovieDetails extends MovieDetailsEvent {
  final String token;
  final String apiToken;
  GetMovieDetails({this.token, this.apiToken});
}
