import 'dart:typed_data';

import 'package:flutter/material.dart';

class User {
  int id;
  String username, password, firstName;
  String address, alternatePhone, landmark, location, profileImage;
  bool isAdmin, isStaff;
  String token, deviceToken;
  Uint8List profileImageBytes;

  User(
      {this.id,
      this.username,
      this.firstName,
      this.address,
      this.password,
      this.landmark,
      this.location,
      this.alternatePhone,
      this.token,
      this.deviceToken,
      this.profileImage,
      this.isAdmin = false,
      this.isStaff = false,
      this.profileImageBytes});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    token = json['token'];
    // address = json['address'];
    isAdmin = json['is_superuser'];
    isStaff = json['is_staff'];

//profile
    //address = json['profile']['address'];
    //landmark = json['profile']['landmark'];
    // location = json['profile']['location'];
    // alternatePhone = json['profile']['alternate_phone'];
    // profileImage = json['profile']['profile_image'];
    // deviceToken = json['profile']['device_token'];
  }

  User.fromStaffJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    isAdmin = json['is_superuser'];
    isStaff = json['is_staff'];
  }
  User.loginCredentials(
      {@required this.username,
      @required this.password,
      @required this.deviceToken});

  User.phoneLoginCredentials({@required this.username});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> profile = new Map<String, dynamic>();
    profile['address'] = this.address;
    profile['location'] = this.location;
    profile['landmark'] = this.landmark;
    profile['alternate_phone'] = this.alternatePhone;
    profile['device_token'] = this.deviceToken;

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['first_name'] = this.firstName;
    data['is_staff'] = this.isStaff;
    data['is_superuser'] = this.isAdmin;
    data['profile'] = profile;

    return data;
  }
}
