class Pivot {
  int crew_id;
  int music_id;

  Pivot({this.crew_id, this.music_id});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      crew_id: json['crew_id'],
      music_id: json['music_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crew_id'] = this.crew_id;
    data['music_id'] = this.music_id;
    return data;
  }
}
