import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import './bloc.dart';

class GenresBloc extends Bloc<GenresEvent, GenresState> {

  final GenresRepository genresRepository;
  GenresBloc({this.genresRepository}) : super(InitialGenresState());

  @override
  GenresState get initialState => InitialGenresState();

  @override
  Stream<GenresState> mapEventToState(
    GenresEvent event,
  ) async* {
    if(event is GetGenresEvent){
      yield LoadingGenresState();
      try{
        var genresList = await genresRepository.fetchGenresList();
        yield genresList!=null||genresList.isEmpty? LoadedGenresState(genresList: genresList):EmptyGenresState();
      }
      catch(e){
        yield ErrorGenresState();
      }
    }
  }
}
