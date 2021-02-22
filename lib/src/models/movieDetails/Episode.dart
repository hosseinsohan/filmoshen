class Episode {
  bool bookmark;
  String cover;
  int id;
  String link;
  String main_title;
  String story;
  String title;
  String token;

  Episode(
      {this.bookmark,
      this.cover,
      this.id,
      this.link,
      this.main_title,
      this.story,
      this.title,
      this.token});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      bookmark: json['bookmark'],
      cover: json['cover'],
      id: json['id'],
      link: json['link'],
      main_title: json['main_title'],
      story: json['story'],
      title: json['title'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookmark'] = this.bookmark;
    data['cover'] = this.cover;
    data['id'] = this.id;
    data['link'] = this.link;
    data['main_title'] = this.main_title;
    data['story'] = this.story;
    data['title'] = this.title;
    data['token'] = this.token;
    return data;
  }
}
