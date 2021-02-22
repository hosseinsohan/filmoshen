import 'package:filimo/src/models/category/Category.dart';
import 'package:filimo/src/models/genres/Genres.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryEvent {}

class AppStartedEvent extends CategoryEvent {}

class RefreshCategoryEvent extends CategoryEvent {}

class LoadMoreCategoryEvent extends CategoryEvent {
  final List<Category> categories;
  LoadMoreCategoryEvent({this.categories});
}
