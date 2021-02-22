import 'package:filimo/src/models/music/MCategories.dart';

class AudioCategoriesList {
  MCategories m_categories;

  AudioCategoriesList({this.m_categories});

  factory AudioCategoriesList.fromJson(Map<String, dynamic> json) {
    return AudioCategoriesList(
      m_categories: json['m_categories'] != null
          ? MCategories.fromJson(json['m_categories'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.m_categories != null) {
      data['m_categories'] = this.m_categories.toJson();
    }
    return data;
  }
}
