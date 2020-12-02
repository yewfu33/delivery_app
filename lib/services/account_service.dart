import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/uiModels/login_model.dart';
import 'package:delivery_app/models/uiModels/register_model.dart';
import 'package:delivery_app/services/api_service.dart';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountService extends ApiService {
  void setPrefs(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('uid', body['id']);
    prefs.setString('uname', body['name'].toString());
    prefs.setString('phone_num', body['phone_num']);
    prefs.setString('token', body['token']);
  }

  Future sendVerificationCode(int code) async {
    try {
      final res = await http.post(
        serverName + 'api/verification',
        headers: headers,
        body: json.encode({
          'value': code.toString(),
        }),
      );

      print(res.statusCode);
    } on SocketException catch (e) {
      print("socket exception in \"sendVerificationCode\", " + e.toString());
      return null;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<http.Response> login(LoginModel model) async {
    try {
      return await client.post(
        serverName + accountPath + '/authenticate',
        headers: headers,
        body: json.encode(model.toMap()),
      );
    } on SocketException catch (e) {
      print("socket exception in \"login\", " + e.toString());
      return Future.error('Request timeout please try again later');
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<http.Response> register(RegisterModel model) async {
    try {
      return await client.post(
        serverName + accountPath + '/register',
        headers: headers,
        body: json.encode(model.toMap()),
      );
    } on SocketException catch (e) {
      print("timeout exception in \"register\", " + e.toString());
      return Future.error('Request timeout please try again later');
    } catch (err) {
      return null;
    }
  }
}
