import 'package:filimo/src/models/bookMark/BookmarkX.dart';

class User {
  String api_token;
  List<BookmarkX> bookmarks;
  String created_at;
  String email;
  String email_verified_at;
  int id;
  String loginCode;
  String mobile;
  String name;
  String subscribe;
  String subscribe_expire_date;
  String updated_at;

  User(
      {this.api_token,
      this.bookmarks,
      this.created_at,
      this.email,
      this.email_verified_at,
      this.id,
      this.loginCode,
      this.mobile,
      this.name,
      this.subscribe,
      this.subscribe_expire_date,
      this.updated_at});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      api_token: json['api_token'],
      bookmarks: json['bookmarks'] != null
          ? (json['bookmarks'] as List)
              .map((i) => BookmarkX.fromJson(i))
              .toList()
          : null,
      created_at: json['created_at'],
      email: json['email'] != null ? json['email'] : null,
      email_verified_at:
          json['email_verified_at'] != null ? json['email_verified_at'] : null,
      id: json['id'],
      loginCode: json['loginCode'],
      mobile: json['mobile'],
      name: json['name'],
      subscribe: json['subscribe'] != null ? json['subscribe'] : null,
      subscribe_expire_date: json['subscribe_expire_date'] != null
          ? json['subscribe_expire_date']
          : null,
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_token'] = this.api_token;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['loginCode'] = this.loginCode;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['updated_at'] = this.updated_at;
    if (this.bookmarks != null) {
      data['bookmarks'] = this.bookmarks.map((v) => v.toJson()).toList();
    }
    if (this.email != null) {
      data['email'] = this.email;
    }
    if (this.email_verified_at != null) {
      data['email_verified_at'] = this.email_verified_at;
    }
    if (this.subscribe != null) {
      data['subscribe'] = this.subscribe;
    }
    if (this.subscribe_expire_date != null) {
      data['subscribe_expire_date'] = this.subscribe_expire_date;
    }
    return data;
  }
}
