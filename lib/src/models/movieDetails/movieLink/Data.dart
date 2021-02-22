class Data {
  List<String> mp4_videos;
  String video_url;

  Data({this.mp4_videos, this.video_url});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      mp4_videos: json['mp4_videos'] != null
          ? new List<String>.from(json['mp4_videos'])
          : null,
      video_url: json['hls_playlist'],
    );
  }
}
