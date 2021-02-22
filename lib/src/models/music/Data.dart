import 'package:filimo/src/models/music/Music.dart';

class Data {
  int id;
  int indexShow;
  List<Music> musics;
  String slug;
  String title;
  String token;

  Data(
      {this.id,
      this.indexShow,
      this.musics,
      this.slug,
      this.title,
      this.token});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      indexShow: json['indexShow'],
      musics: json['musics'] != null
          ? (json['musics'] as List).map((i) => Music.fromJson(i)).toList()
          : null,
      slug: json['slug'],
      title: json['title'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['indexShow'] = this.indexShow;
    data['slug'] = this.slug;
    data['title'] = this.title;
    data['token'] = this.token;
    if (this.musics != null) {
      data['musics'] = this.musics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
