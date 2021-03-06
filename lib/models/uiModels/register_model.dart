import 'package:delivery_app/models/user_type.dart';
import 'package:flutter/foundation.dart';

class RegisterModel {
  final String name;
  final String password;
  final String phoneNum;
  final String fcmToken;
  final UserType userType;

  RegisterModel({
    @required this.name,
    @required this.password,
    @required this.phoneNum,
    @required this.fcmToken,
    @required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'phone_num': phoneNum,
      'fcm_token': fcmToken,
      'user_type': userType.index,
    };
  }
}
