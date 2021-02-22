class Pivot {
  int crew_id;
  int movie_id;

  Pivot({this.crew_id, this.movie_id});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      crew_id: json['crew_id'],
      movie_id: json['movie_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crew_id'] = this.crew_id;
    data['movie_id'] = this.movie_id;
    return data;
  }
}
