import 'package:delivery_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/routes_name.dart' as route;

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Future<SharedPreferences> p = SharedPreferences.getInstance();
  int uid;
  String uname;
  String phoneNum;

  @override
  void initState() {
    p.then((prefs) {
      setState(() {
        uid = prefs.getInt("uid");
        uname = prefs.getString("uname");
        phoneNum = prefs.getString("phone_num");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text((uname != null) ? uname : ""),
                    subtitle: Text((phoneNum != null) ? '+60$phoneNum' : ""),
                  ),
                  const Divider(height: 8, thickness: 0.666),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.contact_phone, size: 30),
                    title: const Text('Personal details'),
                    subtitle:
                        const Text('Password, name, phone number, and email'),
                  ),
                  ListTile(
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationIcon: FlutterLogo(),
                        applicationName: "Delivery App",
                        applicationVersion: "1.0",
                        children: <Widget>[
                          Text('empty here'),
                        ],
                      );
                    },
                    leading: const Icon(Icons.info_outline, size: 30),
                    title: const Text('About'),
                    subtitle: const Text('Version, licenses'),
                  ),
                  const Divider(height: 6, thickness: 0.666),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          textColor: Constant.primaryColor,
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushReplacementNamed(
                                context, route.mainpage);
                          },
                          child: const Text('LOG OUT'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
