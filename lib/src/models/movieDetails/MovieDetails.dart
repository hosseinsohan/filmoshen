import 'package:filimo/src/models/movieDetails/Age.dart';
import 'package:filimo/src/models/movieDetails/Comment.dart';
import 'package:filimo/src/models/movieDetails/Factors.dart';
import 'package:filimo/src/models/movieDetails/Movie.dart';
import 'package:filimo/src/models/movieDetails/Session.dart';

import 'Actor.dart';

class MovieDetails {
  List<Actor> actors;
  bool bookmark;
  List<Comment> comments;
  Factors factors;
  Movie movie;
  String movie_type;
  Age age;
  int subscribe_days;
  String omdbApiKey;

  MovieDetails(
      {this.actors,
      this.bookmark,
      this.comments,
      this.factors,
      this.movie,
      this.movie_type,
      this.age,
      this.subscribe_days,
      this.omdbApiKey});

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      actors: json['actors'] != null
          ? (json['actors'] as List).map((i) => Actor.fromJson(i)).toList()
          : null,
      bookmark: json['bookmark'],
      comments: json['comments'] != null
          ? (json['comments'] as List).map((i) => Comment.fromJson(i)).toList()
          : null,
      factors:
          json['factors'] != null ? Factors.fromJson(json['factors']) : null,
      movie: json['movie'] != null ? Movie.fromJson(json['movie']) : null,
      movie_type: json['movie_type'],
      age: json['age'] != null ? Age.fromJson(json['age']) : null,
      subscribe_days:
          json['subscribe_days'] != null ? json['subscribe_days'] : null,
      omdbApiKey: json['omdb_api_key'] != null ? json['omdb_api_key'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookmark'] = this.bookmark;
    data['movie_type'] = this.movie_type;
    if (this.actors != null) {
      data['actors'] = this.actors.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.factors != null) {
      data['factors'] = this.factors.toJson();
    }
    if (this.movie != null) {
      data['movie'] = this.movie.toJson();
    }
    return data;
  }
}
