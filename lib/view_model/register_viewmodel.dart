import 'dart:convert';
import 'dart:math';

import 'package:delivery_app/helper/throttle.dart';
import 'package:delivery_app/models/uiModels/login_model.dart';
import 'package:delivery_app/models/uiModels/register_model.dart';
import 'package:delivery_app/models/user_type.dart';
import 'package:delivery_app/services/account_service.dart';
import 'package:delivery_app/services/notification_service.dart';
import 'package:delivery_app/view_model/base_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class RegisterViewModel extends BaseViewModel {
  final AccountService accountService = AccountService();
  final NotificationService notificationService = NotificationService();

  bool autoValidateForm = false;
  static int generatedVerificationCode;
  int tryAgainInSeconds;
  final int max = 99999;
  final int min = 10000;
  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  get scaffoldKey => _scaffoldKey;

  //throttle api call, only can call another one after 10sec pass
  final Function throttleSendVerificationCode = throttle(10, () {
    AccountService.sendVerificationCode(generatedVerificationCode);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('Verification Code sent'),
      ),
    );
  });

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
      onLoading(true, context);

      try {
        final RegisterModel model = new RegisterModel(
          name: this.nameField,
          password: this.passwordField,
          phoneNum: this.phoneNumField,
          fcmToken: await notificationService.getFcmToken(),
          userType: UserType.User,
        );

        // register
        var registerRes = await accountService.register(model);

        if (registerRes == null) throw Exception('fail to reach /register');

        if (registerRes.statusCode == 200) {
          var registerResBody = json.decode(registerRes.body);

          final LoginModel loginModel = new LoginModel(
            phoneNum: registerResBody['phone_num'],
            password: registerResBody['password'],
          );

          // perform login
          var loginRes = await accountService.login(loginModel);

          if (loginRes.statusCode == 200) {
            var loginResBody = json.decode(loginRes.body);

            await accountService.setPrefs(loginResBody);

            _formKey.currentState.reset();

            //hide loading banner
            onLoading(false, context);

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) => Home()), (route) => false);
          } else {
            // error 400 maybe
            onLoading(false, context);
            showErrorDialog(context, message: loginRes.reasonPhrase);
          }
        } else {
          // error 400 maybe
          onLoading(false, context);
          showErrorDialog(context, message: registerRes.reasonPhrase);
        }
      } catch (e) {
        // error 400 maybe
        onLoading(false, context);
        showErrorDialog(context, message: e.toString());
      }
    }
  }

  void sendVerificationCode() {
    final rng = Random();
    RegisterViewModel.generatedVerificationCode = rng.nextInt(max - min) + min;

    throttleSendVerificationCode();
  }
}
