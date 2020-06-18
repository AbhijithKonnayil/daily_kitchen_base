class ShopSettings {
  int id;
  String title;
  bool shopOpen;
  String shopOpenTime;
  String shopCloseTime;
  String intervalStartTime;
  String intervalEndTime;

  double deliveryCharge;

  ShopSettings(
      {this.id,
      this.title,
      this.shopOpen,
      this.shopOpenTime,
      this.shopCloseTime,
      this.intervalStartTime,
      this.intervalEndTime,
      this.deliveryCharge});

  ShopSettings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shopOpen = json['shop_open'];
    shopOpenTime = json['shop_open_time'];
    shopCloseTime = json['shop_close_time'];
    intervalStartTime = json['interval_start_time'];
    intervalEndTime = json['interval_end_time'];
    deliveryCharge = json['delivery_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['shop_open'] = this.shopOpen;
    data['shop_open_time'] = this.shopOpenTime;
    data['shop_close_time'] = this.shopCloseTime;
    data['interval_start_time'] = this.intervalStartTime;
    data['interval_end_time'] = this.intervalEndTime;
    data['delivery_charge'] = this.deliveryCharge;
    return data;
  }
}
