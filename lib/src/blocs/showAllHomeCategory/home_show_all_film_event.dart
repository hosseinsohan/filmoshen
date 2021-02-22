import 'package:meta/meta.dart';

@immutable
abstract class HomeShowAllFilmEvent {}

class GetHomeShowAllFilmEvent extends HomeShowAllFilmEvent {
  final String slug;
  GetHomeShowAllFilmEvent({this.slug});
}

class GetCategoryListDetailsEvent extends HomeShowAllFilmEvent {
  final String slug;
  GetCategoryListDetailsEvent({this.slug});
}
