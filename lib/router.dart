import 'package:delivery_app/main.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/routes_name.dart' as route;
import 'package:delivery_app/views/addorder_view.dart';
import 'package:delivery_app/views/login_view.dart';
import 'package:delivery_app/views/orderconfirmation_view.dart';
import 'package:delivery_app/views/orderdetail_view.dart';
import 'package:delivery_app/views/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case route.mainpage:
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
      case route.addOrderPage:
        return MaterialPageRoute(builder: (_) => AddOrderView());
      case route.loginPage:
        return CustomMaterialPageRoute(builder: (_) => LoginView());
      case route.registerPage:
        return CustomMaterialPageRoute(builder: (_) => RegisterView());
      case route.orderDetailPage:
        final OrderModel o = settings.arguments as OrderModel;
        return MaterialPageRoute(builder: (_) => OrderDetailView(o: o));
      case route.orderConfirmationPage:
        final List order = settings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => OrderConfirmationPage(
                  newOrder: order[0] as Order,
                  createOrder: order[1] as Future<bool> Function(Order),
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Icon(Icons.directions_car),
            ),
          ),
        );
    }
  }
}

class CustomMaterialPageRoute extends MaterialPageRoute {
  CustomMaterialPageRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // return new FadeTransition(opacity: animation, child: child);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
