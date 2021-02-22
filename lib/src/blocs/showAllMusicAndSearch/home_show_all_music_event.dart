import 'package:meta/meta.dart';

@immutable
abstract class ShowAllFilmEvent {}

class GetShowAllMusicEvent extends ShowAllFilmEvent {
  final String slug;
  GetShowAllMusicEvent({this.slug});
}

class GetMusicSearchEvent extends ShowAllFilmEvent {
  final String text;
  GetMusicSearchEvent({this.text});
}

class GetShowAllMusicAlbumEvent extends ShowAllFilmEvent {
  final String token;
  GetShowAllMusicAlbumEvent({this.token});
}

