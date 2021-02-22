class Age {
  String created_at;
  String icon;
  int id;
  String title;
  String token;
  String updated_at;

  Age(
      {this.created_at,
      this.icon,
      this.id,
      this.title,
      this.token,
      this.updated_at});

  factory Age.fromJson(Map<String, dynamic> json) {
    return Age(
      created_at: json['created_at'],
      icon: json['icon'],
      id: json['id'],
      title: json['title'],
      token: json['token'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['title'] = this.title;
    data['token'] = this.token;
    data['updated_at'] = this.updated_at;
    return data;
  }
}
