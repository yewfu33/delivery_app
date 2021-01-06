import 'dart:convert';
import 'dart:math';

import 'package:delivery_app/models/uiModels/login_model.dart';
import 'package:delivery_app/models/uiModels/register_model.dart';
import 'package:delivery_app/models/user_type.dart';
import 'package:delivery_app/services/account_service.dart';
import 'package:delivery_app/services/notification_service.dart';
import 'package:delivery_app/view_model/base_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class RegisterViewModel extends BaseViewModel with ChangeNotifier {
  final AccountService accountService = AccountService();
  final NotificationService notificationService = NotificationService();

  bool autoValidateForm = false;
  static int generatedVerificationCode;
  int tryAgainInSeconds;
  final int max = 99999;
  final int min = 10000;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  String nameField;
  String passwordField;
  String phoneNumField;
  String verificationCodeField;

  bool validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      autoValidateForm = true;
      notifyListeners();
      return false;
    }
  }

  Future registerAccount(BuildContext context) async {
    if (validateForm()) {
      //show loading banner
      onLoading(context, isLoading: true);

      try {
        final RegisterModel model = RegisterModel(
          name: nameField,
          password: passwordField,
          phoneNum: phoneNumField,
          fcmToken: await notificationService.getFcmToken() as String,
          userType: UserType.user,
        );

        // register
        final registerRes = await accountService.register(model);

        if (registerRes == null) throw Exception('fail to reach /register');

        if (registerRes.statusCode == 200) {
          final registerResBody = json.decode(registerRes.body);

          final LoginModel loginModel = LoginModel(
            phoneNum: registerResBody['phone_num'] as String,
            password: registerResBody['password'] as String,
          );

          // perform login
          final loginRes = await accountService.login(loginModel);

          if (loginRes.statusCode == 200) {
            final loginResBody = json.decode(loginRes.body);

            await accountService.setPrefs(loginResBody as Map<String, dynamic>);

            _formKey.currentState.reset();

            //hide loading banner
            onLoading(context, isLoading: false);

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) => Home()), (route) => false);
          } else {
            // error 400 maybe
            onLoading(context, isLoading: false);
            showErrorDialog(context, message: loginRes.reasonPhrase);
          }
        } else {
          // error 400 maybe
          onLoading(context, isLoading: false);
          showErrorDialog(context, message: registerRes.reasonPhrase);
        }
      } catch (e) {
        // error 400 maybe
        onLoading(context, isLoading: false);
        showErrorDialog(context, message: e.toString());
      }
    }
  }

  Future sendVerificationCode() async {
    final rng = Random();
    generatedVerificationCode = rng.nextInt(max - min) + min;
    print("code = $generatedVerificationCode");

    await accountService.sendVerificationCode(generatedVerificationCode);
    _scaffoldKey.currentState.showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1000),
        content: Text('Verification Code sent'),
      ),
    );
  }
}
