import 'package:delivery_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/routes_name.dart' as route;

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 25),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Center(
                    child: Icon(Icons.local_shipping, size: 45),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  onPressed: () {
                    Navigator.pushNamed(context, route.registerPage);
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 0.4,
                    ),
                  ),
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  elevation: 0,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  onPressed: () {
                    Navigator.pushNamed(context, route.loginPage);
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.4,
                    ),
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
