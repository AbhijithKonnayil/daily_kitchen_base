class Location {
  int id;
  String city;
  String locality;

  Location({this.id, this.city, this.locality});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    locality = json['locality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    data['locality'] = this.locality;
    return data;
  }
}