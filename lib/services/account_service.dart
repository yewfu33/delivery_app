import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/uiModels/login_model.dart';
import 'package:delivery_app/models/uiModels/register_model.dart';
import 'package:delivery_app/services/api_service.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountService extends ApiService {
  static final AccountService _singleton = AccountService._();

  // register sigleton instance
  factory AccountService() => _singleton;

  AccountService._();

  Future setPrefs(Map<String, dynamic> body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('uid', body['id'] as int);
    prefs.setString('uname', body['name'] as String);
    prefs.setString('phone_num', body['phone_num'] as String);
    prefs.setString('token', body['token'] as String);
  }

  static Future sendVerificationCode(int code) async {
    try {
      await http.post(
        '${Constant.serverName}api/verification',
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode({
          'value': code.toString(),
        }),
      );
    } on SocketException {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> login(LoginModel model) async {
    try {
      return await client.post(
        '${Constant.serverName}$accountPath/authenticate',
        headers: headers,
        body: json.encode(model.toMap()),
      );
    } on SocketException {
      return Future.error('Request timeout please try again later');
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> register(RegisterModel model) async {
    try {
      return await client.post(
        '${Constant.serverName}$accountPath/register',
        headers: headers,
        body: json.encode(model.toMap()),
      );
    } on SocketException {
      return Future.error('Request timeout please try again later');
    } catch (e) {
      return null;
    }
  }
}
