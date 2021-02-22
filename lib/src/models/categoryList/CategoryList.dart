import 'package:filimo/src/models/categoryList/Category.dart';

class CategoryList {
  List<Category> categories;

  CategoryList({this.categories});

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((i) => Category.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
