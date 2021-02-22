import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import './bloc.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  final GenresRepository genresRepository;
  CategoryListBloc({this.genresRepository}) : super(EmptyCategoryListState());
  @override
  CategoryListState get initialState => EmptyCategoryListState();

  @override
  Stream<CategoryListState> mapEventToState(
    CategoryListEvent event,
  ) async* {
    if (event is GetCategoryListEvent) {
      yield LoadingCategoryListState();
      try {
        var categories = await genresRepository.fetchCategoryList();
        yield categories.categories.isEmpty
            ? EmptyCategoryListState()
            : LoadedCategoryListState(categories: categories);
      } catch (e) {
        yield EmptyCategoryListState();
      }
    }
  }
}
