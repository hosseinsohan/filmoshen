import 'package:filimo/src/models/genres/Genres.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GenresState {}

class InitialGenresState extends GenresState {}
class EmptyGenresState extends GenresState {}
class ErrorGenresState extends GenresState {}
class LoadingGenresState extends GenresState {}
class LoadedGenresState extends GenresState {
  final List<Genres> genresList;
  LoadedGenresState({this.genresList});
}
