import 'dart:convert';

import 'package:delivery_app/models/uiModels/login_model.dart';

import 'package:delivery_app/services/account_service.dart';
import 'package:delivery_app/view_model/base_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LoginViewModel extends BaseViewModel {
  final AccountService accountService = AccountService();

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

  Future individualLogin(BuildContext context) async {
    if (validateForm()) {
      //show loading banner
      onLoading(true, context);

      final LoginModel model = new LoginModel(
        phoneNum: this.phoneField,
        password: this.passwordField,
      );

      try {
        // login
        var loginRes = await accountService.login(model);

        if (loginRes == null) throw Exception('fail to reach /authenticate');

        if (loginRes.statusCode == 200) {
          var body = json.decode(loginRes.body);

          await accountService.setPrefs(body);

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
      } catch (e) {
        onLoading(false, context);
        print(e.toString());
        showErrorDialog(context, message: e.toString());
      }
    }
  }
}
