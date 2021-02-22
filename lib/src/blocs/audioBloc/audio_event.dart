import 'package:filimo/src/models/music/Data.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AudioEvent {}

class AppStartedEvent extends AudioEvent {}

class RefreshCategoryEvent extends AudioEvent {}

class LoadMoreCategoryEvent extends AudioEvent {
  final List<Data> categories;
  LoadMoreCategoryEvent({this.categories});
}
