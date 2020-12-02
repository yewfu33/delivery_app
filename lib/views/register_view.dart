import 'package:delivery_app/constants.dart';
import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/register_viewmodel.dart';
import 'package:delivery_app/widgets/MyInputDecoration.dart';
import 'package:delivery_app/wrappers/loading_view_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  final _controller = new TextEditingController(text: '+60 ');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: LoadingViewWrapper(
        child: Consumer<RegisterViewModel>(
          builder: (_, model, __) => Scaffold(
            key: model.scaffoldKey,
            appBar: AppBar(
              title: Text('Create Account'),
              leading: BackButton(onPressed: () => Navigator.pop(context)),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 25.0,
                  ),
                  child: Form(
                    key: model.formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: TextFormField(
                            validator: model.nameFieldValidator,
                            onSaved: model.nameFieldOnSave,
                            decoration: myDecoration('First name*', null),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: TextFormField(
                            validator: model.passwordFieldValidator,
                            onSaved: model.pwFieldOnSave,
                            obscureText: true,
                            decoration: myDecoration('Password*', null),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: TextFormField(
                            validator: model.phoneFieldValidator,
                            onSaved: model.phoneFieldOnSave,
                            controller: _controller,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              CustomPhoneNumberFormatter(),
                            ],
                            decoration: myDecoration('Phone number*',
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
                              textColor: primaryColor,
                              child: Text('SEND SMS VERIFICATION CODE'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: model.verificationCodeFieldValidator,
                            onSaved: model.codeFieldOnSave,
                            decoration:
                                myDecoration('SMS verification code', null),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                // onLoading(context);
                                model.registerAccount(context);
                              },
                              color: primaryColor,
                              textColor: Colors.white,
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  letterSpacing: letterSpacing,
                                ),
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
          ),
        ),
      ),
    );
  }
}
