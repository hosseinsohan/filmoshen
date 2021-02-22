import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import './bloc.dart';

class ShowBookMarkBloc extends Bloc<ShowBookMarkEvent, ShowBookMarkState> {
  final GenresRepository genresRepository;
  ShowBookMarkBloc({this.genresRepository}) : super(InitialShowBookMarkState());
  //@override
 // ShowBookMarkState get initialState => InitialShowBookMarkState();

  @override
  Stream<ShowBookMarkState> mapEventToState(
    ShowBookMarkEvent event,
  ) async* {
    if (event is GetBookMarkListEvent) {
      yield LoadingShowBookMarkState();
      try {
        var showBookMark = await genresRepository.showBookmark(event.apiToken);
        yield showBookMark == null
            ? ErrorShowBookMarkState()
            : showBookMark.bookmarks.isEmpty
                ? EmptyShowBookMarkState()
                : LoadedShowBookMarkState(showBookMark: showBookMark);
      } catch (e) {
        yield ErrorShowBookMarkState();
      }
    } else if (event is GetSearchResultEvent) {
      yield LoadingShowBookMarkState();
      try {
        var showSearchResult =
            await genresRepository.fetchSearchResult(event.text);
        yield showSearchResult == null
            ? ErrorShowBookMarkState()
            : showSearchResult.isEmpty
                ? EmptyShowBookMarkState()
                : LoadedShowSearchResultState(movies: showSearchResult);
      } catch (e) {
        yield ErrorShowBookMarkState();
      }
    } else if (event is GetViewedEvent) {
      yield LoadingShowBookMarkState();
      try {
        var movies = await genresRepository.fethViewedMovie(event.apiToken);
        yield movies == null
            ? ErrorShowBookMarkState()
            : movies.isEmpty
                ? EmptyShowBookMarkState()
                : LoadedShowSearchResultState(movies: movies);
      } catch (e) {
        yield ErrorShowBookMarkState();
      }
    }
  }
}
