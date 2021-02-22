class Movie {
  String cover;
  String token;
  String main_title;
  String title;
  String poster;

  Movie({this.cover, this.token, this.main_title, this.title, this.poster});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      cover: json['cover'],
      token: json['token'],
      main_title: json['main_title'],
      title: json['title'],
      poster: json['poster'],
    );
  }
}
