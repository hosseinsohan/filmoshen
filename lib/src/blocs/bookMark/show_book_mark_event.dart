import 'package:meta/meta.dart';

@immutable
abstract class ShowBookMarkEvent {}

class GetViewedEvent extends ShowBookMarkEvent {
  final String apiToken;
  GetViewedEvent({this.apiToken});
}

class GetBookMarkListEvent extends ShowBookMarkEvent {
  final String apiToken;
  GetBookMarkListEvent({this.apiToken});
}

class GetSearchResultEvent extends ShowBookMarkEvent {
  final String text;
  GetSearchResultEvent({this.text});
}
