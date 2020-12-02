import 'package:flutter/foundation.dart';

class LoginModel {
  final String phoneNum;
  final String password;

  LoginModel({@required this.phoneNum, @required this.password});

  Map<String, String> toMap() => {
        'phone_num': phoneNum,
        'password': password,
      };
}
