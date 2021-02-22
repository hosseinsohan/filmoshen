import 'package:filimo/src/models/search/Res.dart';

class SearchResultModel {
  Res res;
  bool status;

  SearchResultModel({this.res, this.status});

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      res: json['res'] != null ? Res.fromJson(json['res']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.res != null) {
      data['res'] = this.res;
    }
    return data;
  }
}
