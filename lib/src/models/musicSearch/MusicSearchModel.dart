import 'package:filimo/src/models/music/Music.dart';

class MusicSearchModel {
  List<Music> musics;
  bool status;

  MusicSearchModel({this.musics, this.status});

  factory MusicSearchModel.fromJson(Map<String, dynamic> json) {
    return MusicSearchModel(
      musics: json['musics'] != null
          ? (json['musics'] as List).map((i) => Music.fromJson(i)).toList()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.musics != null) {
      data['musics'] = this.musics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
