import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:daily_kitchen_base/data/database/database.dart';
import 'package:daily_kitchen_base/data/models/item.dart';
import 'package:daily_kitchen_base/data/models/item_category.dart';
import 'package:daily_kitchen_base/data/models/order.dart';
import 'package:daily_kitchen_base/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'base_repository.dart';

class ItemRepository extends BaseRepository {
  UserRepository userRepository;
  ItemRepository({@required this.userRepository});

  DBHelper dbHelper = DBHelper();

  getItems({category}) async {
    try {
      if (category != null) {
        return await getReq(
            endpoint: "item/view/$category", userRepository: userRepository);
      } else {
        return await getReq(
            endpoint: "item/view", userRepository: userRepository);
      }
    } catch (e) {
      throw (e);
    }
  }

  getAdminItems({category}) async {
    try {
      if (category != null) {
        return await getReq(
            endpoint: "item/admin-view/$category",
            userRepository: userRepository);
      } else {
        return await getReq(
            endpoint: "item/admin-view", userRepository: userRepository);
      }
    } catch (e) {
      throw (e);
    }
  }

  getOfferItems({category}) async {
    try {
      return await getReq(
          endpoint: "item/view_offer", userRepository: userRepository);
    } catch (e) {
      throw (e);
    }
  }

  getAdminOfferItems({category}) async {
    try {
      return await getReq(
          endpoint: "item/admin-view/view_offer",
          userRepository: userRepository);
    } catch (e) {
      throw (e);
    }
  }

  deleteItem(Item item) async {
    try {
      var response = deleteReq(
          endpoint: 'item/delete/' + item.itemId.toString(),
          userRepository: userRepository);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  addItem(Item item) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(endpointURL("item/add")),
      );
      var response = await buildAndSendRequest(request, item);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  updateItem(Item item) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(endpointURL("item/update/" + item.itemId.toString())),
      );

      var response = await buildAndSendRequest(request, item);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  deleteCategory(ItemCategory itemCategory) async {
    try {
      var response = deleteReq(
          endpoint: 'item/category/delete/' + itemCategory.id.toString(),
          userRepository: userRepository);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  addCategory(ItemCategory itemCategory) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(endpointURL("item/category/add")),
      );
      var response = await buildAndSendCategoryRequest(request, itemCategory);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  updateCategory(ItemCategory itemCategory) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            endpointURL("item/category/update/" + itemCategory.id.toString())),
      );

      var response = await buildAndSendCategoryRequest(request, itemCategory);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  Future<File> writeToFile(Uint8List data, int index) async {
    Directory tempDir = await getTemporaryDirectory();
    String filename = DateFormat("ddMMyyhhmmss").format(DateTime.now());
    String tempPath = tempDir.path;
    var filePath = tempPath +
        '/' +
        filename +
        "-" +
        index.toString() +
        '.jpeg'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(data);
  }

  getOrderList() async {
    try {
      var response = await getReq(
          endpoint: "order/view/individual", userRepository: userRepository);
      Iterable orderList = json.decode(response.body);
      List<Order> orders =
          orderList.map((model) => Order.fromJson(model)).toList();
      return orders;
    } catch (e) {
      throw (e);
    }
  }

  getAdminOrderList() async {
    try {
      var response =
          await getReq(endpoint: "order/view", userRepository: userRepository);
      Iterable orderList = json.decode(response.body);
      List<Order> orders =
          orderList.map((model) => Order.fromJson(model)).toList();
      return orders;
    } catch (e) {
      throw (e);
    }
  }

  getDeliveryStaffOrderList() async {
    try {
      var response = await getReq(
          endpoint: "order/view/delivery_staff",
          userRepository: userRepository);
      Iterable orderList = json.decode(response.body);
      List<Order> orders =
          orderList.map((model) => Order.fromJson(model)).toList();
      return orders;
    } catch (e) {
      throw (e);
    }
  }

  getCartItems() async {
    try {
      var response = await dbHelper.getCartItems();
      return response;
    } catch (e) {
      throw (e);
    }
  }

  deleteCartItem(int id) async {
    try {
      var response = await dbHelper.deleteCartItem(id);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  placeOrder(Order order) async {
    try {
      var body = order.toJson();
      var response = await postReq(
          endpoint: "order/add", body: body, userRepository: userRepository);
      if (response.statusCode == 201) {
        var res = await dbHelper.deleteCartItems();
      }

      return response;
    } catch (e) {
      throw (e);
    }
  }

  viewOrder(int orderId) async {
    try {
      var response = await getReq(
          endpoint: "order/view/${orderId}", userRepository: userRepository);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  updateOrder(Order order) async {
    try {
      var body = order.toJson();
      var response = await putReq(
          endpoint: "order/update/${order.id}",
          body: body,
          userRepository: userRepository);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  addToCart(Item item) async {
    try {
      return await dbHelper.insertToCart(item);
    } catch (e) {
      throw (e);
    }
  }

  getCategories() async {
    try {
      var response = await getReq(
          endpoint: 'item/category/admin-view', userRepository: userRepository);
      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  deleteOrders(String fromDate, String toDate) async {
    try {
      Map data = {'from_date': fromDate, "to_date": toDate};
      var response = await postReq(
          endpoint: 'order/delete', body: data, userRepository: userRepository);
      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  deleteOrder(int orderId) async {
    try {
      var response = await deleteReq(
          endpoint: 'order/delete/individual/$orderId', userRepository: userRepository);
      if (response.statusCode == 204) {
        return true;
      } else {
        throw ("Error");
      }
    } catch (e) {
      return false;
    }
  }

  buildAndSendRequest(http.MultipartRequest request, Item item) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Token " + userRepository.user.token,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      request.headers.addAll(headers);
      request
        ..fields['title'] = item.title
        ..fields['discount'] = item.discount.toString()
        ..fields['rate_per_quantity'] = item.ratePerQuantity.toString()
        ..fields['category_id'] = item.itemCategory.id.toString()
        ..fields['description'] = item.description
        ..fields['hide'] = item.hide.toString()
        ..fields['rate_unit'] = item.rateUnit;

      var i = 0;
      for (var each in item.byteImages) {
        request.files.add(await http.MultipartFile(
            'item_images', http.ByteStream.fromBytes(each), each.length,
            filename:
                "${DateFormat("ddMMyyhhmmss").format(DateTime.now())}_$i.jpeg",
            contentType: MediaType('image', 'jpeg')));
      }
      var response = await request.send();
      return response;
    } catch (e) {
      throw (e);
    }
  }

  buildAndSendCategoryRequest(
      http.MultipartRequest request, ItemCategory itemCategory) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Token " + userRepository.user.token
      };
      request.headers.addAll(headers);

      request
        ..fields['title'] = itemCategory.title
        ..fields['cleaning_charge'] = itemCategory.cleaningCharge.toString()
        ..fields['hide'] = itemCategory.hide.toString();

      if (itemCategory.imageBytes != null) {
        request.files.add(await http.MultipartFile(
            'image',
            http.ByteStream.fromBytes(itemCategory.imageBytes),
            itemCategory.imageBytes.length,
            filename: "${itemCategory.title}_${itemCategory.id}.jpeg",
            contentType: MediaType('image', 'jpeg')));
      }
      var response = await request.send();
      return response;
    } catch (e) {
      throw (e);
    }
  }

  sendCustomerNotification(Order order) async {
    http.post(
        "https://us-central1-daily-kitchen-app.cloudfunctions.net/pushNotificationToCustomers",
        body: json.encode({
          "orderId": order.id,
          "orderStatus": order.status,
          "deviceToken": order.user.deviceToken
        }),
        headers: {'Content-Type': 'application/json'});
  }

  sendDeliveryStaffNotification(Order order) async {
    http.post(
        "https://us-central1-daily-kitchen-app.cloudfunctions.net/pushNotificationToDeliveryStaff",
        body: json.encode({"orderId": order.id, "deviceToken": order.deliveryStaff.deviceToken}),
        headers: {'Content-Type': 'application/json'});
  }
}
