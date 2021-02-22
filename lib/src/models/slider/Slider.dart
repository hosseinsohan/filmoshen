class Slider {
  String description;
  String image;
  int movie_id;
  String movie_token;
  String name_image;

  Slider(
      {this.description,
      this.image,
      this.movie_id,
      this.movie_token,
      this.name_image});

  factory Slider.fromJson(Map<String, dynamic> json) {
    return Slider(
      description: json['description'],
      image: json['image'],
      movie_id: json['movie_id'],
      movie_token: json['movie_token'],
      name_image: json['name_image'] != null ? json['name_image'] : null,
    );
  }
}
