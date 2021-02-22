import 'package:filimo/src/models/music/AudioCategoriesList.dart';
import 'package:filimo/src/models/music/Data.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AudioState {}

class InitialAudioState extends AudioState {}

class EmptyAudioState extends AudioState {}

class ErrorAudioState extends AudioState {}

class LoadingAudioState extends AudioState {}

class LoadedAudioState extends AudioState {
  final List<Data> audioCategoriesList;
  LoadedAudioState({this.audioCategoriesList});
}
