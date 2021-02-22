import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import './bloc.dart';

class GetAllCommentsBloc
    extends Bloc<GetAllCommentsEvent, GetAllCommentsState> {
  GenresRepository genresRepository;
  GetAllCommentsBloc({this.genresRepository}) : super(InitialGetAllCommentsState());
  @override
  GetAllCommentsState get initialState => InitialGetAllCommentsState();

  @override
  Stream<GetAllCommentsState> mapEventToState(
    GetAllCommentsEvent event,
  ) async* {
    if (event is GetCommentsEvent) {
      yield LoadingGetAllCommentsState();
      try {
        var comments = await genresRepository.fetchAllComments(
            event.apiToken, event.dataToken, event.type);
        yield comments.isEmpty
            ? EmptyGetAllCommentsState()
            : LoadedGetAllCommentsState(comments: comments);
      } catch (e) {
        print(e);
        LoadingGetAllCommentsState();
      }
    }
  }
}
