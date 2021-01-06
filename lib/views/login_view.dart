import 'package:delivery_app/constants.dart';
import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/login_viewmodel.dart';
import 'package:delivery_app/widgets/MyInputDecoration.dart';
import 'package:delivery_app/wrappers/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//individual form
class IndividualLoginView extends StatelessWidget {
  final BuildContext parentContext;

  const IndividualLoginView({Key key, @required this.parentContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginViewModel>(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
        child: Form(
          key: model.formKey,
          autovalidate: model.autoValidateForm,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  initialValue: '+60 ',
                  validator: (v) {
                    if (v == '+60 ') {
                      return 'This field is required';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (v) {
                    model.phoneField = v.substring(4);
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    CustomPhoneNumberFormatter(),
                  ],
                  decoration: myDecoration('Phone number*'),
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
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: myDecoration('Password*'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      // bring down the keyboard
                      FocusScope.of(context).unfocus();

                      model.individualLogin(parentContext);
                    },
                    color: Constant.primaryColor,
                    textColor: Colors.white,
                    child: const Text(
                      'Log-in',
                      style: TextStyle(fontSize: 17.0, letterSpacing: 0.4),
                    ),
                  ),
                ),
              ),
              //reset password
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FlatButton(
                    onPressed: () {},
                    textColor: Constant.primaryColor,
                    child: const Text('RESET PASSWORD'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: LoadingDialog(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sign-in'),
            leading: BackButton(onPressed: () => Navigator.pop(context)),
            bottom: const TabBar(
              labelColor: Colors.white,
              indicatorColor: Constant.primaryColor,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'FOR INDIVIDUALS',
                    style: TextStyle(
                      fontSize: 16.0,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'FOR BUSINESSES',
                    style: TextStyle(
                      fontSize: 16.0,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: ChangeNotifierProvider(
            create: (_) => LoginViewModel(),
            child: TabBarView(
              children: [
                IndividualLoginView(parentContext: context),
                Column(
                  children: const [
                    Expanded(
                        child: Center(child: Icon(Icons.directions_transit))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
