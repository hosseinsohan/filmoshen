import 'package:filimo/src/models/categoryList/Category.dart';
import 'package:filimo/src/models/music/Data.dart';
import 'package:filimo/src/models/music/Music.dart';

class ShowAllMusic {
  List<Data> categories;
  List<Music> musics;

  ShowAllMusic({this.categories, this.musics});

  factory ShowAllMusic.fromJson(Map<String, dynamic> json) {
    return ShowAllMusic(
      categories: json['categories'] != null
          ? (json['categories'] as List).map((i) => Data.fromJson(i)).toList()
          : null,
      musics: json['musics'] != null
          ? (json['musics'] as List).map((i) => Music.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.musics != null) {
      data['musics'] = this.musics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
