import 'Comment.dart';

class SendLikeModel {
  Comment comment;
  int like_status;
  bool status;

  SendLikeModel({this.comment, this.like_status, this.status});

  factory SendLikeModel.fromJson(Map<String, dynamic> json) {
    return SendLikeModel(
      comment:
          json['comment'] != null ? Comment.fromJson(json['comment']) : null,
      like_status: json['like_status'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['like_status'] = this.like_status;
    data['status'] = this.status;
    if (this.comment != null) {
      data['comment'] = this.comment.toJson();
    }
    return data;
  }
}
