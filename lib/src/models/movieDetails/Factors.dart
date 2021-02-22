import 'package:filimo/src/models/movieDetails/Writer.dart';

class Factors {
  List<Writer> composers;
  List<Writer> directors;
  List<Writer> photography;
  List<Writer> producers;
  List<Writer> writers;

  Factors(
      {this.composers,
      this.directors,
      this.photography,
      this.producers,
      this.writers});

  factory Factors.fromJson(Map<String, dynamic> json) {
    return Factors(
      composers: json['composers'] != null
          ? (json['composers'] as List).map((i) => Writer.fromJson(i)).toList()
          : null,
      directors: json['directors'] != null
          ? (json['directors'] as List).map((i) => Writer.fromJson(i)).toList()
          : null,
      photography: json['photography'] != null
          ? (json['photography'] as List)
              .map((i) => Writer.fromJson(i))
              .toList()
          : null,
      producers: json['producers'] != null
          ? (json['producers'] as List).map((i) => Writer.fromJson(i)).toList()
          : null,
      writers: json['writers'] != null
          ? (json['writers'] as List).map((i) => Writer.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.composers != null) {
      data['composers'] = this.composers.map((v) => v.toJson()).toList();
    }
    if (this.directors != null) {
      data['directors'] = this.directors.map((v) => v.toJson()).toList();
    }
    if (this.photography != null) {
      data['photography'] = this.photography.map((v) => v.toJson()).toList();
    }
    if (this.producers != null) {
      data['producers'] = this.producers.map((v) => v.toJson()).toList();
    }
    if (this.writers != null) {
      data['writers'] = this.writers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
