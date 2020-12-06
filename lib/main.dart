import 'package:delivery_app/constants.dart';
import 'package:delivery_app/pages/OrdersPage.dart';
import 'package:delivery_app/routes_name.dart' as route;

import 'package:delivery_app/locator.dart';
import 'package:delivery_app/pages/Landing.dart';
import 'package:delivery_app/router.dart';
import 'package:delivery_app/services/navigation_service.dart';
import 'package:delivery_app/views/addorder_view.dart';
import 'package:delivery_app/views/profile_view.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // setting up getit
  setupLocator();
  // obtain .env variables
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Constant.primaryColor),
      onGenerateRoute: Router.onGenerateRoute,
      initialRoute: route.mainpage,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _isLoggedIn;

  //children page
  final List<Widget> _children = [
    OrdersPage(),
    AddOrderView(),
    ProfileView(),
  ];

  final bottomBarStyle =
      TextStyle(letterSpacing: 0.4, fontWeight: FontWeight.w500);

  @override
  void initState() {
    _isLoggedIn = _prefs.then((prefs) => prefs.containsKey("uid"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isLoggedIn,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          default:
            if (!snapshot.data) {
              return Landing();
            } else {
              return Scaffold(
                // body: PageTransitionSwitcher(
                //   child: _children[_currentIndex],
                //   transitionBuilder:
                //       (child, primaryAnimation, secondaryAnimation) {
                //     return SharedAxisTransition(
                //       animation: primaryAnimation,
                //       secondaryAnimation: secondaryAnimation,
                //       transitionType: SharedAxisTransitionType.horizontal,
                //       child: child,
                //     );
                //   },
                // ),
                body: _children[_currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  onTap: (int index) {
                    if (index == 1) {
                      Navigator.pushNamed(context, route.addOrderPage);
                      return;
                    }
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  backgroundColor: Constant.primaryColor,
                  fixedColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  currentIndex: _currentIndex,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.assignment),
                      title: Text('Orders', style: bottomBarStyle),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_box),
                      title: Text('Add Order', style: bottomBarStyle),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_box),
                      title: Text('Profile', style: bottomBarStyle),
                    ),
                  ],
                ),
              );
            }
        }
      },
    );
  }
}
