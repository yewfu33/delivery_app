import 'dart:convert';

import 'package:delivery_app/locator.dart';
import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/services/navigation_service.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:delivery_app/routes_name.dart' as route;
import 'package:flutter/foundation.dart';

class ActiveOrderViewModel with ChangeNotifier {
  OrderService orderService = locator<OrderService>();
  NavigationService navigationService = locator<NavigationService>();

  bool _busy = true;
  get isBusy => _busy;

  void setBusy(bool b) {
    _busy = b;
    notifyListeners();
  }

  List<OrderModel> _orders;
  List<OrderModel> get orders => _orders;

  void navigateToDetails(OrderModel order) {
    navigationService.navigateTo(route.orderDetailPage, arguments: order);
  }

  Future<List<OrderModel>> fetchActiveOrder() async {
    try {
      var res = await orderService.getOrdersByUserId();
      if (res == null) throw Exception('failed to fetch active order');

      if (res.statusCode == 200) {
        List<dynamic> body = json.decode(res.body);

        return body.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
