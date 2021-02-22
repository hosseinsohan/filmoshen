import 'package:filimo/src/models/music/musicLink/Data.dart';

class MusicLinkModel {
  Data data;

  MusicLinkModel({this.data});

  factory MusicLinkModel.fromJson(Map<String, dynamic> json) {
    return MusicLinkModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
