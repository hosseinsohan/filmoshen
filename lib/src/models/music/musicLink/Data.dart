import 'package:filimo/src/models/music/musicLink/ConvertInfo.dart';

class Data {
  String audioUrl;
  String playerUrl;
  List<ConvertInfo> convert_info;
  List<String> mp4_audios;
  Data({this.audioUrl, this.playerUrl, this.convert_info, this.mp4_audios});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      audioUrl: json['audio_url'],
      playerUrl: json['player_url'],
      convert_info: json['convert_info'] != null
          ? (json['convert_info'] as List)
              .map((i) => ConvertInfo.fromJson(i))
              .toList()
          : null,
      mp4_audios: json['mp4_audios'] != null
          ? new List<String>.from(json['mp4_audios'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audio_url'] = this.audioUrl;
    data['player_url'] = this.playerUrl;

    return data;
  }
}
