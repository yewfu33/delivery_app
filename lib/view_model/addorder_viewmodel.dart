import 'package:delivery_app/models/drop_point.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/routes_name.dart' as route;

class AddOrderViewModel with ChangeNotifier {
  final OrderService orderService = OrderService();
  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;
  bool autoValidateForm = false;
  Order order = new Order();

  bool validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      autoValidateForm = true;
      notifyListeners();
      return false;
    }
  }

  void saveOrder(BuildContext context) async {
    if (validateForm()) {
      print('valid form');
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('user id: ' + prefs.get('uid').toString());

        order.userId = prefs.get('uid');
      } catch (err) {
        print(err);
      }

      Navigator.pushNamed(
        context,
        route.orderConfirmationPage,
        arguments: [
          order,
          createOrder,
        ],
      );
    }
  }

  Future<bool> createOrder(Order o) async {
    try {
      var res = await orderService.postOrder(o);
      if (res == null) throw Exception('fail to post order');

      if (res.statusCode == 201) {
        //success
        print('created');
        return true;
      } else {
        print('status code: ' + res.statusCode.toString());
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void updateVehicleType(int index) {
    order.vehicleType = index;
  }

  void removeLastDropPoint() {
    order.dropPoint.removeLast();
    notifyListeners();
  }

  void addDropPoint() {
    order.dropPoint.add(new DropPoint());
    notifyListeners();
  }

  void notifySenderOnChanged() {
    order.notifyMebySMS = !order.notifyMebySMS;
  }

  void notifyRecipientOnChanged() {
    order.notifyRecipientbySMS = !order.notifyRecipientbySMS;
  }
}
