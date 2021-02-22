import 'Subscribe.dart';

class SubscribeListModel {
  List<Subscribe> subscribe;

  SubscribeListModel({this.subscribe});

  factory SubscribeListModel.fromJson(Map<String, dynamic> json) {
    return SubscribeListModel(
      subscribe: json['subscribe'] != null
          ? (json['subscribe'] as List)
              .map((i) => Subscribe.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subscribe != null) {
      data['subscribe'] = this.subscribe.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
