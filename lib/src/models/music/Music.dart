import 'package:filimo/src/models/music/Singer.dart';

class Music {
  String cover;
  String created_at;
  int id;
  String main_title;
  List<Singer> singers;
  String title;
  String link;
  String token;
  int viewCount;
  String type;

  Music(
      {this.cover,
      this.created_at,
      this.id,
      this.main_title,
      this.singers,
      this.title,
      this.token,
      this.viewCount,
      this.link,
      this.type});

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
        cover: json['cover'],
        created_at: json['created_at'],
        id: json['id'],
        main_title: json['main_title'],
        singers: json['singers'] != null
            ? (json['singers'] as List).map((i) => Singer.fromJson(i)).toList()
            : null,
        title: json['title'],
        token: json['token'],
        viewCount: json['viewCount'],
        link: json['link'],
    type: json['type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover'] = this.cover;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['main_title'] = this.main_title;
    data['title'] = this.title;
    data['token'] = this.token;
    data['viewCount'] = this.viewCount;
    if (this.singers != null) {
      data['singers'] = this.singers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
