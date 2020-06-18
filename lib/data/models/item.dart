import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';


import 'package:daily_kitchen_base/data/models/item_category.dart';
import 'package:http/http.dart';

class Item {
  int id;
  int itemId;
  String title;
  String description;
  double ratePerQuantity;
  String rateUnit;
  double discount;
  double noOfUnits;
  bool hide;
  ItemCategory itemCategory;
  bool cleaningRequired;
  double totalAmount;
  List<File> images;
  List<Uint8List> byteImages;
  List<Uri> imageUrls;

  Item(
      {this.id,
      this.itemId,
      this.title,
      this.description,
      this.ratePerQuantity,
      this.rateUnit,
      this.discount,
      this.noOfUnits,
      this.totalAmount,
      this.hide,
      this.images,
      this.cleaningRequired,
      this.itemCategory,
      this.byteImages,
      this.imageUrls});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['id'];
    title = json['title'];
    description = json['description'];
    if (json['category'] != null) {
      itemCategory = ItemCategory.fromJson(json['category']);
    }

    ratePerQuantity = json['rate_per_quantity'];
    rateUnit = json['rate_unit'];
    hide = json['hide'];
    discount = json['discount'];
    imageUrls = List<Uri>.generate(
        json['images'].length, (i) => Uri.parse(json['images'][i]));
  }
  Item.fromOrderItemJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item']['id'];
    title = json['item']['title'];
    description = json['item']['description'];
    ratePerQuantity = json['item']['rate_per_quantity'];
    rateUnit = json['item']['rate_unit'];
    hide = json['item']['hide'];
    discount = json['item']['discount'];
    cleaningRequired = json['cleaning_required'];
    if (json['item']['category'] != null) {
      itemCategory = ItemCategory.fromJson(json['item']['category']);
    }
    noOfUnits = json['no_of_units'];
    totalAmount = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['rate_per_quantity'] = this.ratePerQuantity;
    data['rate_unit'] = this.rateUnit;
    data['discount'] = this.discount;
    data['no_of_units'] = this.noOfUnits;
    data['total_amount'] = this.totalAmount;
    data['cleaning_required'] = this.cleaningRequired;
    data['hide'] = this.hide;
    
    //data['category'] = this.itemCategory;
    //data['image'] = MultipartFile();
    return data;
  }

  Map<String, dynamic> toJsonForSqlite() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['title'] = this.title;
    data['rate_per_quantity'] = this.ratePerQuantity;
    data['rate_unit'] = this.rateUnit;
    data['discount'] = this.discount;
    data['no_of_units'] = this.noOfUnits;
    data['total_amount'] = this.totalAmount;
    data['cleaning_required'] = this.cleaningRequired ? 1 : 0;
    //data['category'] = this.itemCategory;
    //data['image'] = MultipartFile();
    return data;
  }
}
