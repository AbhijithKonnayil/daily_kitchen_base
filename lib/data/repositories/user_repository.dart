import 'dart:convert';

import 'package:daily_kitchen_base/data/models/user.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository {
  User user;
  getUser() async {
    String userString;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userString = prefs.getString('user');
    if (userString != null) {
      user = User.fromJson(json.decode(userString));
      return user;
    } else {
      return null;
    }
  }

  loginUser(String username, String password, String deviceToken) async {
    try {
      print(endpointURL("user/login"));
      var response = await http.post(endpointURL("user/login"),
          body: json.encode(User.loginCredentials(
                  username: username,
                  password: password,
                  deviceToken: deviceToken)
              .toJson()),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        dataToSharedPreference('user', response.body);
      }else{
        var jsonResponse = json.decode(response.body);
        throw(jsonResponse['message']);
      }
      return response;
    } catch (e) {
      throw (e);
    }
  }

  phoneLoginUser(String phone) async {
    try {
      var response = await http.post(endpointURL("user/phone_login"),
          body:
              json.encode(User.phoneLoginCredentials(username: phone).toJson()),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        dataToSharedPreference('user', response.body);
      }
      return response.statusCode;
    } catch (e) {
      throw (e);
    }
  }

  registerUser(User user) async {
    try {
      var response = await http.post(endpointURL("user/register"),
          body: json.encode(user.toJson()),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {}
      return response;
    } catch (e) {
      throw (e);
    }
  }

  updateUser(User user) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Token " + this.user.token
      };
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(endpointURL("user/update/" + user.id.toString())),
      );
      request.headers.addAll(headers);
      request
        ..fields['first_name'] = user.firstName
        ..fields['username'] = user.username
        ..fields['location'] = user.location
        ..fields['address'] = user.address
        ..fields['landmark'] = user.landmark
        ..fields['device_token'] = user.deviceToken
        ..fields['alternate_phone'] = user.alternatePhone;

      if (user.profileImageBytes != null) {
        request.files.add(await http.MultipartFile(
            'profile_image',
            http.ByteStream.fromBytes(user.profileImageBytes),
            user.profileImageBytes.length,
            filename: "${user.username}.jpeg",
            contentType: MediaType('image', 'jpeg')));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        await dataToSharedPreference('user', responseString);
      }
      return response;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> logoutUser() async {
    try {
      var response = await http.get(endpointURL("user/logout"),
          headers: {"Authorization": "Token " + user.token});

      if (response.statusCode == 204) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        return true;
      }else{
        throw("Logout Failed");
      }
    } catch (e) {
      return false;
    }
  }

  dataToSharedPreference(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<bool> isLoggedIn() async {
    var user = await getUser();
    return user is User ? true : false;
  }

  getStaffList() async {
    try {
      var response =
          await getReq(endpoint: 'user/staff/list', userRepository: this);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  deleteStaffList(User staff) async {
    try {
      var response = await deleteReq(
          endpoint: 'user/staff/delete/${staff.id}', userRepository: this);
      return response;
    } catch (e) {
      throw (e);
    }
  }
}
