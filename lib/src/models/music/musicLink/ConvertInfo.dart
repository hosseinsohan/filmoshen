class ConvertInfo {
  int audio_bitrate;

  ConvertInfo({this.audio_bitrate});

  factory ConvertInfo.fromJson(Map<String, dynamic> json) {
    return ConvertInfo(
      audio_bitrate: json['audio_bitrate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audio_bitrate'] = this.audio_bitrate;
    return data;
  }
}
