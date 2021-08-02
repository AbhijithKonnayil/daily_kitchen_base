import 'dart:convert';

import 'package:daily_kitchen_base/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseRepository {
  //static String BASE_URL = "http://15.206.66.115/";
  static String BASE_URL = "http://192.168.1.8:8000/";

  String endpointURL(String endpoint) {
    return BASE_URL + endpoint + "/";
  }

  getReq({@required endpoint, @required UserRepository userRepository}) async {
    try {
      var response = await http.get(endpointURL(endpoint),
          headers: {"Authorization": "Token " + userRepository.user.token});
      return response;
    } catch (e) {
      throw (e);
    }
  }

  postReq(
      {@required endpoint,
      @required body,
      UserRepository userRepository}) async {
    try {
      return await http
          .post(endpointURL(endpoint), body: json.encode(body), headers: {
        "Authorization": "Token " + userRepository.user.token,
        'Content-Type': 'application/json'
      });
    } catch (e) {
      throw (e);
    }
  }

  putReq(
      {@required endpoint,
      @required body,
      UserRepository userRepository}) async {
    try {
      return await http
          .put(endpointURL(endpoint), body: json.encode(body), headers: {
        "Authorization": "Token " + userRepository.user.token,
        'Content-Type': 'application/json'
      });
    } catch (e) {
      throw (e);
    }
  }

  deleteReq(
      {@required endpoint, @required UserRepository userRepository}) async {
    try {
      return await http.delete(endpointURL(endpoint), headers: {
        "Authorization": "Token " + userRepository.user.token,
        'Content-Type': 'application/json'
      });
    } catch (e) {
      throw (e);
    }
  }
}
