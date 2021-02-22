class BookmarkX {
  String created_at;
  int id;
  String movie_token;
  String updated_at;
  int user_id;

  BookmarkX(
      {this.created_at,
      this.id,
      this.movie_token,
      this.updated_at,
      this.user_id});

  factory BookmarkX.fromJson(Map<String, dynamic> json) {
    return BookmarkX(
      created_at: json['created_at'],
      id: json['id'],
      movie_token: json['movie_token'],
      updated_at: json['updated_at'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['movie_token'] = this.movie_token;
    data['updated_at'] = this.updated_at;
    data['user_id'] = this.user_id;
    return data;
  }
}
