import 'package:delivery_app/constants.dart';
import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/register_viewmodel.dart';
import 'package:delivery_app/widgets/MyInputDecoration.dart';
import 'package:delivery_app/wrappers/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Consumer<RegisterViewModel>(
        builder: (_, model, __) {
          return LoadingDialog(
            child: Scaffold(
              key: model.scaffoldKey,
              appBar: AppBar(
                title: const Text('Create Account'),
                leading: BackButton(onPressed: () => Navigator.pop(context)),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 25.0),
                  child: Form(
                    key: model.formKey,
                    autovalidate: model.autoValidateForm,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: TextFormField(
                            validator: (v) {
                              if (v.trim().isEmpty) {
                                return 'This field is required';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (v) {
                              model.nameField = v;
                            },
                            decoration: myDecoration('Name*'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: TextFormField(
                            validator: (v) {
                              if (v.trim().isEmpty) {
                                return 'This field is required';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (v) {
                              model.passwordField = v;
                            },
                            obscureText: true,
                            decoration: myDecoration('Password*'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: TextFormField(
                            validator: (v) {
                              if (v == '+60 ') {
                                return 'This field is required';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (v) {
                              model.phoneNumField = v.substring(4);
                            },
                            initialValue: "+60 ",
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              CustomPhoneNumberFormatter(),
                            ],
                            decoration: myDecoration('Phone number*',
                                helperText:
                                    'A SMS verification code will be sent to your registered phone number'),
                          ),
                        ),
                        //send SMS verification code
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FlatButton(
                              onPressed: () {
                                model.sendVerificationCode();
                              },
                              textColor: Constant.primaryColor,
                              child: const Text('SEND SMS VERIFICATION CODE'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v.trim().isEmpty) {
                                return 'This field is required';
                              } else {
                                if (v !=
                                    RegisterViewModel.generatedVerificationCode
                                        .toString()) {
                                  return 'Invalid code';
                                }
                                return null;
                              }
                            },
                            onSaved: (v) {
                              model.verificationCodeField = v;
                            },
                            decoration: myDecoration('SMS verification code'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                // bring down the keyboard
                                FocusScope.of(context).unfocus();
                                // onLoading(context);
                                model.registerAccount(context);
                              },
                              color: Constant.primaryColor,
                              textColor: Colors.white,
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 17.0, letterSpacing: 0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
