import 'dart:convert';

import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ActiveOrderViewModel with ChangeNotifier {
  final OrderService orderService = OrderService();

  bool _busy = true;
  get isBusy => _busy;

  void setBusy(bool b) {
    _busy = b;
    notifyListeners();
  }

  List<OrderModel> _orders;
  List<OrderModel> get orders => _orders;

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
