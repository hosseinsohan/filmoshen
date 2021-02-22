import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/resources/repository/audioRepository.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import './bloc.dart';

class ShowAllMusicBloc extends Bloc<ShowAllFilmEvent, ShowAllMusicState> {
  final AudioRepository audioRepository;
  ShowAllMusicBloc({this.audioRepository}) : super(InitialShowAllMusicState());
  @override
  ShowAllMusicState get initialState => InitialShowAllMusicState();

  @override
  Stream<ShowAllMusicState> mapEventToState(
    ShowAllFilmEvent event,
  ) async* {
    if (event is GetShowAllMusicEvent) {
      yield LoadingShowAllMusicState();
      try {
        var data = await audioRepository.fetchShowAllMusic(event.slug);
        yield data.musics.isEmpty && data.categories.isEmpty
            ? EmptyShowAllMusicState()
            : LoadedShowAllCategoryMusicState(showAllMusic: data);
      } catch (e) {
        yield ErrorShowAllMusicState();
      }
    } else if(event is GetShowAllMusicAlbumEvent){
      yield LoadingShowAllMusicState();
      try {
        var data = await audioRepository.fetchShowAllMusicAlbum(event.token);
        yield data.musics.isEmpty && data.categories.isEmpty
            ? EmptyShowAllMusicState()
            : LoadedShowAllCategoryMusicState(showAllMusic: data);
      } catch (e) {
        yield ErrorShowAllMusicState();
      }
    }
    else if (event is GetMusicSearchEvent) {
      yield LoadingShowAllMusicState();
      try {
        var musics = await audioRepository.fetchMusicSearchResult(event.text);
        yield musics.isEmpty
            ? EmptyShowAllMusicState()
            : LoadedShowAllMusicState(musics: musics);
      } catch (e) {
        yield ErrorShowAllMusicState();
      }
    }
  }
}
