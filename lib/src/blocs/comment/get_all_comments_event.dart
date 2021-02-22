import 'package:meta/meta.dart';

@immutable
abstract class GetAllCommentsEvent {}

class GetCommentsEvent extends GetAllCommentsEvent {
  final String apiToken;
  final String dataToken;
  final String type;
  GetCommentsEvent({this.apiToken, this.dataToken, this.type});
}
