import 'package:filimo/src/models/SubscribeList/SubscribeListModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SubscribeListState {}

class InitialSubscribeListState extends SubscribeListState {}

class EmptySubscribeListState extends SubscribeListState {}

class ErrorSubscribeListState extends SubscribeListState {}

class LoadingSubscribeListState extends SubscribeListState {}

class LoadedSubscribeListState extends SubscribeListState {
  final SubscribeListModel subscribeListModel;
  LoadedSubscribeListState({this.subscribeListModel});
}
