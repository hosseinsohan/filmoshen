import 'Data.dart';

class MCategories {
  List<Data> data;
  int current_page;
  String first_page_url;
  int from;
  int last_page;
  String last_page_url;
  String next_page_url;
  String path;
  int per_page;
  String prev_page_url;
  int to;
  int total;

  MCategories(
      {this.data,
      this.current_page,
      this.first_page_url,
      this.from,
      this.last_page,
      this.last_page_url,
      this.next_page_url,
      this.path,
      this.per_page,
      this.prev_page_url,
      this.to,
      this.total});

  factory MCategories.fromJson(Map<String, dynamic> json) {
    return MCategories(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => Data.fromJson(i)).toList()
          : null,
      current_page: json['current_page'],
      first_page_url: json['first_page_url'],
      from: json['from'],
      last_page: json['last_page'],
      last_page_url: json['last_page_url'],
      next_page_url:
          json['next_page_url'] != null ? json['next_page_url'] : null,
      path: json['path'],
      per_page: json['per_page'],
      prev_page_url:
          json['prev_page_url'] != null ? json['prev_page_url'] : null,
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.current_page;
    data['first_page_url'] = this.first_page_url;
    data['from'] = this.from;
    data['last_page'] = this.last_page;
    data['last_page_url'] = this.last_page_url;
    data['path'] = this.path;
    data['per_page'] = this.per_page;
    data['to'] = this.to;
    data['total'] = this.total;
    if (this.data != null) {
      data['`data`'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.next_page_url != null) {
      data['next_page_url'] = this.next_page_url;
    }
    if (this.prev_page_url != null) {
      data['prev_page_url'] = this.prev_page_url;
    }
    return data;
  }
}
