class Bookmark {
  String about;
  int age_id;
  String cover;
  String created_at;
  int dislikeCount;
  int genre_id;
  int id;
  String imdb_id;
  int likeCount;
  String link;
  String main_title;
  String poster;
  int status;
  String story;
  String time;
  String title;
  String token;
  String type;
  String updated_at;

  Bookmark(
      {this.about,
      this.age_id,
      this.cover,
      this.created_at,
      this.dislikeCount,
      this.genre_id,
      this.id,
      this.imdb_id,
      this.likeCount,
      this.link,
      this.main_title,
      this.poster,
      this.status,
      this.story,
      this.time,
      this.title,
      this.token,
      this.type,
      this.updated_at});

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      about: json['about'],
      age_id: json['age_id'],
      cover: json['cover'],
      created_at: json['created_at'],
      dislikeCount: json['dislikeCount'],
      genre_id: json['genre_id'],
      id: json['id'],
      imdb_id: json['imdb_id'] != null ? json['imdb_id'] : null,
      likeCount: json['likeCount'],
      link: json['link'],
      main_title: json['main_title'],
      poster: json['poster'],
      status: json['status'],
      story: json['story'],
      time: json['time'] != null ? json['time'] : null,
      title: json['title'],
      token: json['token'],
      type: json['type'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about'] = this.about;
    data['age_id'] = this.age_id;
    data['cover'] = this.cover;
    data['created_at'] = this.created_at;
    data['dislikeCount'] = this.dislikeCount;
    data['genre_id'] = this.genre_id;
    data['id'] = this.id;
    data['likeCount'] = this.likeCount;
    data['link'] = this.link;
    data['main_title'] = this.main_title;
    data['poster'] = this.poster;
    data['status'] = this.status;
    data['story'] = this.story;
    data['title'] = this.title;
    data['token'] = this.token;
    data['type'] = this.type;
    data['updated_at'] = this.updated_at;
    if (this.imdb_id != null) {
      data['imdb_id'] = this.imdb_id;
    }
    if (this.time != null) {
      data['time'] = this.time;
    }
    return data;
  }
}
