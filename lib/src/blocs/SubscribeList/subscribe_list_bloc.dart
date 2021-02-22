import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/resources/repository/genres_repository.dart';
import './bloc.dart';

class SubscribeListBloc extends Bloc<SubscribeListEvent, SubscribeListState> {
  final GenresRepository genresRepository;
  SubscribeListBloc({this.genresRepository}) : super(InitialSubscribeListState());
  @override
  SubscribeListState get initialState => InitialSubscribeListState();

  @override
  Stream<SubscribeListState> mapEventToState(
    SubscribeListEvent event,
  ) async* {
    if (event is GetSubscribeListEvent) {
      yield LoadingSubscribeListState();
      try {
        var subscribeListModel = await genresRepository.showSubscribeList();
        yield subscribeListModel == null
            ? ErrorSubscribeListState()
            : subscribeListModel.subscribe.isEmpty
                ? EmptySubscribeListState()
                : LoadedSubscribeListState(
                    subscribeListModel: subscribeListModel);
      } catch (e) {
        yield ErrorSubscribeListState();
      }
    }
  }
}
