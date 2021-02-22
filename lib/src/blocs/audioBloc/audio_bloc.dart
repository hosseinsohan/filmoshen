import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/models/music/Data.dart';
import 'package:filimo/src/resources/repository/audioRepository.dart';
import './bloc.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioRepository audioRepository;
  AudioBloc({this.audioRepository}) : super(InitialAudioState());

  /*@override
  AudioState get initialState => InitialAudioState();*/

  @override
  Stream<AudioState> mapEventToState(
    AudioEvent event,
  ) async* {
    if (event is AppStartedEvent) {
      yield* _mapAppStartedToState();
    } else if (event is RefreshCategoryEvent) {
      yield* _getCategories(categories: []);
    } else if (event is LoadMoreCategoryEvent) {
      yield* _mapLoadMoreCategoryToState(event);
    }
  }

  Stream<AudioState> _getCategories(
      {List<Data> categories, int page = 1}) async* {
    try {
      List<Data> newCategoryList =
          categories + await audioRepository.fetchAudioList(page);
      yield LoadedAudioState(audioCategoriesList: newCategoryList);
    } catch (err) {
      print(err);
      yield ErrorAudioState();
    }
  }

  Stream<AudioState> _mapAppStartedToState() async* {
    yield LoadingAudioState();
    yield* _getCategories(categories: []);
  }

  Stream<AudioState> _mapLoadMoreCategoryToState(
      LoadMoreCategoryEvent event) async* {
    final int nextPage = (event.categories.length / 4).ceil() + 1;
    print(nextPage);
    yield* _getCategories(categories: event.categories, page: nextPage);
  }
}
