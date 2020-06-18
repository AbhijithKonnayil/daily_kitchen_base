
import 'package:daily_kitchen_base/data/models/location.dart';
import 'package:daily_kitchen_base/data/models/shop_setting.dart';
import 'package:daily_kitchen_base/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'base_repository.dart';
import 'package:http/http.dart' as http;

class ShopSettingsRepository extends BaseRepository {
  UserRepository userRepository;
  ShopSettingsRepository({@required this.userRepository});
  ShopSettings shopSettings;

  getShopSettings() async {
    try {
      var response =
          await getReq(endpoint: "shop/view", userRepository: userRepository);
      if (response.statusCode == 200) {
        ShopSettings shopSettings =
            ShopSettings.fromJson(json.decode(response.body));
            this.shopSettings = shopSettings;
        return shopSettings;
      } else {
        throw ("Network Error");
      }
    } catch (e) {
      throw (e);
    }
  }

  updateShopSettings(ShopSettings shopSettings) async {
    try {
      var response = await putReq(
          endpoint: "shop/update",
          body: shopSettings.toJson(),
          userRepository: userRepository);
      if (response.statusCode == 200) {
        ShopSettings shopSettings =
            ShopSettings.fromJson(json.decode(response.body));
        return shopSettings;
      } else {
        throw ("Network Error");
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Location>> getLocations() async {
    try {
      var response = await http.get(
        endpointURL('shop/locations'),
      );
      Iterable locationList = json.decode(response.body);
      List<Location> locations =
          locationList.map((model) => Location.fromJson(model)).toList();
      return locations;
    } catch (e) {
      throw (e);
    }
  }

  addLocation(Location location) async {
    try {
      var response = await postReq(
        endpoint: 'shop/locations/add',
        body: location.toJson(),
        userRepository: userRepository,
      );
      return response;
    } catch (e) {
      throw (e);
    }
  }

  updateLocation(Location location) async {
    try {
      var response = await putReq(
        endpoint: 'shop/locations/update/${location.id}',
        body: location.toJson(),
        userRepository: userRepository,
      );
      return response;
    } catch (e) {
      throw (e);
    }
  }

  deleteLocation(Location location) async {
    try {
      var response = await deleteReq(
        endpoint: 'shop/locations/delete/${location.id}',
        userRepository: userRepository,
      );
      return response;
    } catch (e) {
      throw (e);
    }
  }
}
