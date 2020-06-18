

import 'package:daily_kitchen_base/data/models/item.dart';
import 'package:daily_kitchen_base/data/models/user.dart';

class Order {
  int id;
  User user, deliveryStaff;
  List<Item> orderItemDetails;
  double netAmount;
  String orderedDateTime;
  String address, landmark, location;
  double lat, lon;
  String status;

  Order({
    this.id,
    this.user,
    this.deliveryStaff,
    this.orderItemDetails,
    this.address,
    this.landmark,
    this.location,
    this.lat,
    this.lon,
    this.status,
    this.netAmount,
    this.orderedDateTime,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = User.fromJson(json['user']);
    if (json['order_item_details'] != null) {
      orderItemDetails = new List<Item>();
      json['order_item_details'].forEach((v) {
        orderItemDetails.add(new Item.fromOrderItemJson(v));
      });
    }
    if (json['delivery_staff'] != null) {
      deliveryStaff = User.fromJson(json['delivery_staff']);
    }

    netAmount = json['net_amount'];
    orderedDateTime = json['ordered_date_time'];
    address = json['address'];
    landmark = json['landmark'];
    location = json['location'];
    status = json['status'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    //data['user']=this.user.toJson();
    if (this.orderItemDetails != null) {
      data['order_item_details'] =
          this.orderItemDetails.map((v) => v.toJson()).toList();
    }
    data['delivery_staff'] = this.deliveryStaff;
    data['net_amount'] = this.netAmount;
    data['ordered_date_time'] = this.orderedDateTime;
    data['address'] = this.address;
    data['location'] = this.location;
    data['landmark'] = this.landmark;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['status'] = this.status;
    return data;
  }
}
