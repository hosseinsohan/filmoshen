import 'package:meta/meta.dart';

@immutable
abstract class SubscribeListEvent {}

class GetSubscribeListEvent extends SubscribeListEvent {
  GetSubscribeListEvent();
}
