import 'package:filimo/src/models/movieDetails/Pivot.dart';

class Actor {
  String avatar;
  String birth;
  String created_at;
  String description;
  int id;
  String main_name;
  String name;
  Pivot pivot;
  String slug;
  String updated_at;

  Actor(
      {this.avatar,
      this.birth,
      this.created_at,
      this.description,
      this.id,
      this.main_name,
      this.name,
      this.pivot,
      this.slug,
      this.updated_at});

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      avatar: json['avatar'],
      birth: json['birth'],
      created_at: json['created_at'],
      description: json['description'],
      id: json['id'],
      main_name: json['main_name'],
      name: json['name'],
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
      slug: json['slug'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['birth'] = this.birth;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['id'] = this.id;
    data['main_name'] = this.main_name;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['updated_at'] = this.updated_at;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}
