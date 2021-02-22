import 'package:filimo/src/models/CategoryListDetails/CategoryListDetails.dart';
import 'package:filimo/src/models/category/Movie.dart';
import 'package:filimo/src/models/music/Music.dart';
import 'package:filimo/src/models/showAllMusic/ShowAllMusic.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ShowAllMusicState {}

class InitialShowAllMusicState extends ShowAllMusicState {}

class EmptyShowAllMusicState extends ShowAllMusicState {}

class ErrorShowAllMusicState extends ShowAllMusicState {}

class LoadingShowAllMusicState extends ShowAllMusicState {}

class LoadedShowAllMusicState extends ShowAllMusicState {
  final List<Music> musics;
  LoadedShowAllMusicState({this.musics});
}

class LoadedShowAllCategoryMusicState extends ShowAllMusicState {
  final ShowAllMusic showAllMusic;
  LoadedShowAllCategoryMusicState({this.showAllMusic});
}
