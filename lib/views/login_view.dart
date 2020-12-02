import 'package:delivery_app/constants.dart';
import 'package:delivery_app/util.dart';
import 'package:delivery_app/view_model/login_viewmodel.dart';
import 'package:delivery_app/widgets/MyInputDecoration.dart';
import 'package:delivery_app/wrappers/loading_view_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/routes_name.dart' as route;

//individual form
class IndividualLoginView extends StatelessWidget {
  final _controller = new TextEditingController(text: '+60 ');

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginViewModel>(context, listen: false);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 25.0,
          horizontal: 25.0,
        ),
        child: Form(
          key: model.formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  controller: _controller,
                  validator: model.phoneFieldValidator,
                  onSaved: model.phoneFieldOnSave,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    CustomPhoneNumberFormatter(),
                  ],
                  decoration: myDecoration('Phone number*', null),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  validator: model.passwordFieldValidator,
                  onSaved: model.pwFieldOnSave,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: myDecoration('Password*', null),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      model.individualLogin(context);
                    },
                    color: primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      'Log-in',
                      style: TextStyle(
                        fontSize: 17.0,
                        letterSpacing: letterSpacing,
                      ),
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
                    textColor: primaryColor,
                    child: Text('RESET PASSWORD'),
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
      child: LoadingViewWrapper(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Sign-in'),
            leading: BackButton(onPressed: () => Navigator.pop(context)),
            bottom: TabBar(
              labelColor: Colors.white,
              indicatorColor: primaryColor,
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
                IndividualLoginView(),
                Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, route.mainpage, (_) => false);
                      },
                      child: Text('home'),
                    ),
                    Icon(Icons.directions_transit),
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
