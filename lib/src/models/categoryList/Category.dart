class Category {
  int id;
  String slug;
  String title;
  String token;
  String url;

  Category({this.id, this.slug, this.title, this.token, this.url});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      token: json['token'],
      url: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['title'] = this.title;
    data['token'] = this.token;
    return data;
  }
}
