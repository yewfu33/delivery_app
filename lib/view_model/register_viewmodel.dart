import 'dart:convert';
import 'dart:math';

import 'package:delivery_app/helper/throttle.dart';
import 'package:delivery_app/locator.dart';
import 'package:delivery_app/models/uiModels/login_model.dart';
import 'package:delivery_app/models/uiModels/register_model.dart';
import 'package:delivery_app/models/user_type.dart';
import 'package:delivery_app/services/account_service.dart';
import 'package:delivery_app/services/navigation_service.dart';
import 'package:delivery_app/view_model/base_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:delivery_app/routes_name.dart' as route;

class RegisterViewModel extends BaseViewModel {
  final AccountService accountService = locator<AccountService>();
  final NavigationService navigationService = locator<NavigationService>();

  bool autoValidateForm = false;
  static int generatedVerificationCode;
  int tryAgainInSeconds;
  int max = 99999;
  int min = 10000;
  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  get scaffoldKey => _scaffoldKey;

  //throttle api call, only can call another one after 10sec pass
  final Function throttleSendVerificationCode = throttle(10, () {
    locator<AccountService>().sendVerificationCode(generatedVerificationCode);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('Verification code sent'),
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

  void registerAccount(BuildContext context) async {
    if (validateForm()) {
      //show loading banner
      onLoading(true);

      RegisterModel model = new RegisterModel(
          name: this.nameField,
          password: this.passwordField,
          phoneNum: this.phoneNumField,
          userType: UserType.User);

      try {
        Response res = await accountService.register(model);

        if (res == null) throw Exception('fail to reach /register');

        if (res.statusCode == 200) {
          Map<String, dynamic> registerResBody = json.decode(res.body);

          LoginModel loginModel = new LoginModel(
            phoneNum: registerResBody['phone_num'],
            password: registerResBody['password'],
          );

          //register
          accountService.login(loginModel).then((res) {
            if (res.statusCode == 200) {
              Map<String, dynamic> loginResBody = json.decode(res.body);

              accountService.setPrefs(loginResBody);

              _formKey.currentState.reset();

              //hide loading banner
              onLoading(false);

              navigationService.navigateToAndRemoveUntil(route.mainpage);
            } else {
              // error 400 maybe
              onLoading(false);
              showErrorDialog(context);
            }
          }).catchError((e) {
            onLoading(false);
            showErrorDialog(context, message: e.toString());
          });
        } else {
          // error 400 maybe
          onLoading(false);
          showErrorDialog(context);
        }
      } catch (e) {
        // error 400 maybe
        onLoading(false);
        showErrorDialog(context, message: e.toString());
      }
    }
  }

  void sendVerificationCode() {
    final rng = Random();
    RegisterViewModel.generatedVerificationCode = rng.nextInt(max - min) + min;

    throttleSendVerificationCode();
  }

  String nameFieldValidator(String value) {
    if (value.trim().isEmpty) {
      return 'This field is required';
    } else {
      return null;
    }
  }

  String passwordFieldValidator(String value) {
    if (value.trim().isEmpty) {
      return 'This field is required';
    } else {
      return null;
    }
  }

  String phoneFieldValidator(String value) {
    if (value == '+60 ') {
      return 'This field is required';
    } else {
      return null;
    }
  }

  String verificationCodeFieldValidator(String value) {
    if (value.trim().isEmpty) {
      return 'This field is required';
    } else {
      if (value != RegisterViewModel.generatedVerificationCode.toString()) {
        return 'Invalid code';
      }
      return null;
    }
  }

  void nameFieldOnSave(String value) {
    this.nameField = value;
  }

  void pwFieldOnSave(String value) {
    this.passwordField = value;
  }

  void phoneFieldOnSave(String value) {
    this.phoneNumField = value.substring(4);
  }

  void codeFieldOnSave(String value) {
    this.verificationCodeField = value;
  }
}
