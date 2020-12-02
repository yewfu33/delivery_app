import 'dart:convert';

import 'package:delivery_app/models/uiModels/login_model.dart';
import 'package:delivery_app/routes_name.dart' as route;

import 'package:delivery_app/locator.dart';
import 'package:delivery_app/services/account_service.dart';
import 'package:delivery_app/services/navigation_service.dart';
import 'package:delivery_app/view_model/base_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends BaseViewModel {
  final AccountService accountService = locator<AccountService>();
  final NavigationService navigationService = locator<NavigationService>();

  bool autoValidateForm = true;

  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;

  String phoneField;
  String passwordField;

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

  void individualLogin(BuildContext context) async {
    // showErrorDialog(context);
    if (validateForm()) {
      //show loading banner
      onLoading(true);

      LoginModel model = new LoginModel(
        phoneNum: this.phoneField,
        password: this.passwordField,
      );

      // login
      accountService.login(model).then((res) {
        if (res == null) throw Exception('fail to reach /authenticate');

        if (res.statusCode == 200) {
          Map<String, dynamic> body = json.decode(res.body);

          accountService.setPrefs(body);

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

  void phoneFieldOnSave(String value) {
    this.phoneField = value.substring(4);
  }

  void pwFieldOnSave(String value) {
    this.passwordField = value;
  }
}
