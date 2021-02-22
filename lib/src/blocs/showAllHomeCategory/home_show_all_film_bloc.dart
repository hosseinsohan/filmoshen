import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import './bloc.dart';

class HomeShowAllFilmBloc
    extends Bloc<HomeShowAllFilmEvent, HomeShowAllFilmState> {
  final GenresRepository genresRepository;
  HomeShowAllFilmBloc({this.genresRepository}) : super(InitialHomeShowAllFilmState());
  @override
  HomeShowAllFilmState get initialState => InitialHomeShowAllFilmState();

  @override
  Stream<HomeShowAllFilmState> mapEventToState(
    HomeShowAllFilmEvent event,
  ) async* {
    if (event is GetHomeShowAllFilmEvent) {
      yield LoadingHomeShowAllFilmState();
      try {
        var categoryListDetails =
            await genresRepository.fetchCategoryListDetails(event.slug);
        yield categoryListDetails.categories.isEmpty &&
                categoryListDetails.movies.isEmpty
            ? EmptyHomeShowAllFilmState()
            : LoadedCategoryListDetailsState(
                categoryListDetails: categoryListDetails);
      } catch (e) {
        yield ErrorHomeShowAllFilmState();
      }
    } else if (event is GetCategoryListDetailsEvent) {
      yield LoadingHomeShowAllFilmState();
      try {
        var categoryListDetails =
            await genresRepository.fetchCategoryListDetails(event.slug);
        yield categoryListDetails.categories.isEmpty &&
                categoryListDetails.movies.isEmpty
            ? EmptyHomeShowAllFilmState()
            : LoadedCategoryListDetailsState(
                categoryListDetails: categoryListDetails);
      } catch (e) {
        yield ErrorHomeShowAllFilmState();
      }
    }
  }
}
