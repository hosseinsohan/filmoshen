class Comment {
  int auth_user_has_liked;
  String comment;
  String created_at;
  int dislikeCount;
  int id;
  int likeCount;
  bool spoil;
  String user_avatar;
  String user_name;

  Comment(
      {this.auth_user_has_liked,
      this.comment,
      this.created_at,
      this.dislikeCount,
      this.id,
      this.likeCount,
      this.spoil,
      this.user_avatar,
      this.user_name});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      auth_user_has_liked: json['auth_user_has_liked'],
      comment: json['comment'],
      created_at: json['created_at'],
      dislikeCount: json['dislikeCount'],
      id: json['id'],
      likeCount: json['likeCount'],
      spoil: json['spoil'],
      user_avatar: json['user_avatar'] != null ? json['user_avatar'] : null,
      user_name: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth_user_has_liked'] = this.auth_user_has_liked;
    data['comment'] = this.comment;
    data['created_at'] = this.created_at;
    data['dislikeCount'] = this.dislikeCount;
    data['id'] = this.id;
    data['likeCount'] = this.likeCount;
    data['spoil'] = this.spoil;
    data['user_name'] = this.user_name;
    if (this.user_avatar != null) {
      data['user_avatar'] = this.user_avatar;
    }
    return data;
  }
}
