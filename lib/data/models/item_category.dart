import 'dart:typed_data';

class ItemCategory {
  int id;
  String title;
  double cleaningCharge;
  String image;
  Uint8List imageBytes;

  ItemCategory({this.id, this.title, this.cleaningCharge, this.image,this.imageBytes});

  ItemCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cleaningCharge = json['cleaning_charge'];
    image = json['image'];
    imageBytes = json['imageBytes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['cleaning_charge'] = this.cleaningCharge;
    data['image'] = this.image;
    return data;
  }
}
