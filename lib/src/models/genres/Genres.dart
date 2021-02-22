class Genres {
    int id;
    String name;

    Genres({this.id, this.name});

    factory Genres.fromJson(Map<String, dynamic> json) {
        return Genres(
            id: json['id'], 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        return data;
    }
}