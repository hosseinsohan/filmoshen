import 'package:filimo/src/models/movieDetails/Comment.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GetAllCommentsState {}

class InitialGetAllCommentsState extends GetAllCommentsState {}

class LoadingGetAllCommentsState extends GetAllCommentsState {}

class EmptyGetAllCommentsState extends GetAllCommentsState {}

class LoadedGetAllCommentsState extends GetAllCommentsState {
  final List<Comment> comments;
  LoadedGetAllCommentsState({this.comments});
}
