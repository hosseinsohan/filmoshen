import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import 'package:filimo/src/utils/data.dart';
import './bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GenresRepository genresRepository;
  CategoryBloc({this.genresRepository}) : super(EmptyCategoryState());

  @override
  CategoryState get initialState => EmptyCategoryState();

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is AppStartedEvent) {
      yield* _mapAppStartedToState();
    } else if (event is RefreshCategoryEvent) {
      yield* _getCategories(categories: []);
    } else if (event is LoadMoreCategoryEvent) {
      yield* _mapLoadMoreCategoryToState(event);
    }
  }

  Stream<CategoryState> _getCategories(
      {List<Category> categories, int page = 1}) async* {
    //yield page == 1 ? LoadingCategoryState() : MoreLoadingCategoryState();
    try {
      List<Category> newCategoryList =
          categories + await genresRepository.fetchHomeCategory(page);
      yield LoadedCategoryState(categories: newCategoryList);
    } catch (err) {
      yield ErrorCategoryState();
    }
  }

  Stream<CategoryState> _mapAppStartedToState() async* {
    yield LoadingCategoryState();
    yield* _getCategories(categories: []);
  }

  Stream<CategoryState> _mapLoadMoreCategoryToState(
      LoadMoreCategoryEvent event) async* {
    final int nextPage = (event.categories.length / 4).ceil() + 1;
    print(nextPage);
    yield* _getCategories(categories: event.categories, page: nextPage);
  }
}
