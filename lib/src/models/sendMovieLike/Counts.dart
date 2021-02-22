class Counts {
  int dislikeCount;
  int likeCount;

  Counts({this.dislikeCount, this.likeCount});

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      dislikeCount: json['dislikeCount'],
      likeCount: json['likeCount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dislikeCount'] = this.dislikeCount;
    data['likeCount'] = this.likeCount;
    return data;
  }
}
