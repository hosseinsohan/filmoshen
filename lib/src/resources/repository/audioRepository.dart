import 'dart:io';

import 'package:filimo/src/models/music/AudioCategoriesList.dart';
import 'package:filimo/src/models/music/Data.dart';
import 'package:filimo/src/models/music/Music.dart';
import 'package:filimo/src/models/music/musicLink/MusicLinkModel.dart';
import 'package:filimo/src/models/showAllMusic/ShowAllMusic.dart';
import 'package:filimo/src/resources/api/audio_api.dart';
import 'package:flutter/cupertino.dart';

class AudioRepository {
  AudioApi audioApi;

  AudioRepository({
    @required this.audioApi,
  }) : assert(audioApi != null);

  Future<List<Data>> fetchAudioList(int page) async {
    return await audioApi.fetchAudio(page);
  }

  Future<MusicLinkModel> fetchMusicLink(String link) async {
    return await audioApi.fetchMusicLink(link);
  }

  Future<List<Music>> fetchMusicSearchResult(String text) async {
    return await audioApi.fetchMusicSearchResult(text);
  }

  Future<ShowAllMusic> fetchShowAllMusic(String slug) async {
    return await audioApi.fetchShowAllMusic(slug);
  }

  Future<File> downloadFile(String url, String filename) async {
    return audioApi.downloadFile(url, filename);
  }

  Future<List<FileSystemEntity>> listofFiles() async {
    return await audioApi.listofFiles();
  }
  /*void downloadFile(String name, String url) async {
    return await audioApi.downloadFile(name, url);
  }*/
  Future<ShowAllMusic> fetchShowAllMusicAlbum(String slug) async {
    return await audioApi.fetchShowAllMusicAlbum(slug);
  }

}
