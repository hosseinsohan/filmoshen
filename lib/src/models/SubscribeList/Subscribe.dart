class Subscribe {
  int discount;
  String icon;
  int id;
  int monthCount;
  int price;

  Subscribe({this.discount, this.icon, this.id, this.monthCount, this.price});

  factory Subscribe.fromJson(Map<String, dynamic> json) {
    return Subscribe(
      discount: json['discount'],
      icon: json['icon'],
      id: json['id'],
      monthCount: json['monthCount'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount'] = this.discount;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['monthCount'] = this.monthCount;
    data['price'] = this.price;
    return data;
  }
}
