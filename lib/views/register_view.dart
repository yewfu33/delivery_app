import 'package:delivery_app/constants.dart';
import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/register_viewmodel.dart';
import 'package:delivery_app/widgets/MyInputDecoration.dart';
import 'package:delivery_app/wrappers/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = new TextEditingController(text: '+60 ');
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: LoadingDialog(
        child: Consumer<RegisterViewModel>(builder: (_, model, __) {
          return Scaffold(
            key: model.scaffoldKey,
            appBar: AppBar(
              title: Text('Create Account'),
              leading: BackButton(onPressed: () => Navigator.pop(context)),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
                child: Form(
                  key: model.formKey,
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
                          controller: _controller,
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
                            child: Text('SEND SMS VERIFICATION CODE'),
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
                            child: Text(
                              'Register',
                              style: const TextStyle(
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
          );
        }),
      ),
    );
  }
}
