import 'package:filimo/src/models/sendMovieLike/Counts.dart';

class SendMoveiLike {
  Counts counts;
  int like_status;
  bool status;

  SendMoveiLike({this.counts, this.like_status, this.status});

  factory SendMoveiLike.fromJson(Map<String, dynamic> json) {
    return SendMoveiLike(
      counts: json['counts'] != null ? Counts.fromJson(json['counts']) : null,
      like_status: json['like_status'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['like_status'] = this.like_status;
    data['status'] = this.status;
    if (this.counts != null) {
      data['counts'] = this.counts.toJson();
    }
    return data;
  }
}
