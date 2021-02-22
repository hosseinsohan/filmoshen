import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import './bloc.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GenresRepository genresRepository;
  MovieDetailsBloc({this.genresRepository}) : super(InitialMovieDetailsState());
  @override
  MovieDetailsState get initialState => InitialMovieDetailsState();

  @override
  Stream<MovieDetailsState> mapEventToState(
    MovieDetailsEvent event,
  ) async* {
    if (event is GetMovieDetails) {
      yield LoadingMovieDetailsState();
      try {
        var movieDetails = await genresRepository.fetchMovieDetails(
            event.token, event.apiToken);
        yield LoadedMovieDetailsState(movieDetails: movieDetails);
      } catch (e) {
        yield ErrorMovieDetailsState();
      }
    }
  }
}
