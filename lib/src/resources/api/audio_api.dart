import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:filimo/src/models/music/AudioCategoriesList.dart';
import 'package:filimo/src/models/music/Data.dart';
import 'package:filimo/src/models/music/Music.dart';
import 'package:filimo/src/models/music/musicLink/MusicLinkModel.dart';
import 'package:filimo/src/models/musicSearch/MusicSearchModel.dart';
import 'package:filimo/src/models/showAllMusic/ShowAllMusic.dart';
import 'package:filimo/src/utils/url.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioApi {
  final _baseUrl = '$baseUrl/api/v1/';
  final http.Client httpClient;
  AudioApi({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Data>> fetchAudio(int page) async {
    final url = '$_baseUrl' + 'musics?page=$page';
    print(url);
    final http.Response response = await http.get(
      url,
    );
    print("در حال دریافت اطلاعات");
    print(' music:===> ${response.body}');
    if (response.statusCode == 200) {
      try {
        var audioCategoriesList =
            AudioCategoriesList.fromJson(json.decode(response.body));
        return audioCategoriesList.m_categories.data;
      } catch (e) {
        throw e;
        return [];
      }
    } else {
      return null;
    }
  }

  Future<MusicLinkModel> fetchMusicLink(String link) async {
    final url = 'https://napi.arvancloud.com/vod/2.0/audios/$link';
    print(url);
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Apikey 26c1775d-dd61-4c8a-833f-0c40026fdaf8',
      },
    );
    print("در حال دریافت اطلاعات");
    print(' music:===> ${response.body}');
    if (response.statusCode == 200) {
      try {
        return MusicLinkModel.fromJson(json.decode(response.body));
      } catch (e) {
        throw e;
        //return [];
      }
    } else {
      return null;
    }
  }

  Future<ShowAllMusic> fetchShowAllMusic(String slug) async {
    final url = '${_baseUrl}tag/m/$slug';

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return ShowAllMusic.fromJson(responseJson);
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<ShowAllMusic> fetchShowAllMusicAlbum(String slug) async {
    final url = '${_baseUrl}music/$slug';

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);
      print('eeeeeeeeee${responseJson['album']['tracks']}');
      var data = ShowAllMusic(
        categories: [],
        musics:(responseJson['album']['tracks'] as List).map((i) => Music.fromJson(i)).toList()
      );
      return data;
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }
  Future<List<Music>> fetchMusicSearchResult(String text) async {
    final url = '${_baseUrl}search/music?q=$text';
    Map<String, String> header = {"Accept": "application/json"};

    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);

      return MusicSearchModel.fromJson(responseJson).musics;
      //Categories.fromJson(responseJson);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<File> downloadFile(String url, String filename) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename.mp3');
    print('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<List<FileSystemEntity>> listofFiles() async {
    // Check if directory Exists
    var dir = await getExternalStorageDirectory();
    await createFileDirectory();

    String storagePath = dir.path;

    List<FileSystemEntity> _files;
    List<FileSystemEntity> _songs = [];
    _files = Directory("$storagePath").listSync();
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _songs.add(entity);
    }
    return _songs;
  }

  Future<void> createFileDirectory() async {
    var dir = await getExternalStorageDirectory();
    String storagePath = dir.path;
    bool exists = await Directory(storagePath).exists();
    if (!exists) {
      await Directory(storagePath).create(recursive: true);
    }
  }
/*
  Future get _localPath async {
    // Application documents directory: /data/user/0/{package_name}/{app_name}

    // final applicationDirectory = await getApplicationDocumentsDirectory();

    // // External storage directory: /storage/emulated/0

    final externalDirectory = await getExternalStorageDirectory();

    // // Application temporary directory: /data/user/0/{package_name}/cache

    // final tempDirectory = await getTemporaryDirectory();

    return externalDirectory.path;
  }

  get _musicStoragePath async {
    String basePath = await _localPath;
    return basePath + '/muzic/';
  }

  Future<void> createFileDirectory() async {
    String storagePath = await _musicStoragePath;
    bool exists = await Directory(storagePath).exists();
    if (!exists) {
      await Directory(storagePath).create(recursive: true);
    }
  }

  void downloadFile(String name, String url) async {
    Dio dio = new Dio();
    String storagePath = await _musicStoragePath;
    // String fileName = AppFunctions.randomString(9) + ".mp3";
    String fileName = "$name.mp3";

    String fullStoragePath = storagePath + fileName;

    // Check if directory Exists
    await createFileDirectory();

    await dio.download(url, fullStoragePath);
  }

  Future<List<FileSystemEntity>> listofFiles() async {
    List<FileSystemEntity> files;
    // Check if directory Exists
    await createFileDirectory();

    String storagePath = await _musicStoragePath;
    files = Directory("$storagePath").listSync();
    return files;
  }*/
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      print(responseJson);
      return responseJson;
    case 400:
      throw response.body.toString();
    case 401:
    case 403:
      throw response.body.toString();
    case 500:
    default:
      throw 'Error occured while Communication with Server with StatusCode : ${response.statusCode}';
  }
}
