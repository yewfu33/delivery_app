import 'package:delivery_app/locator.dart';
import 'package:delivery_app/models/drop_point.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/services/navigation_service.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/routes_name.dart' as route;

class AddOrderViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  bool autoValidateForm = false;
  Order order = new Order();

  bool validateForm() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      autoValidateForm = true;
      notifyListeners();
      return false;
    }
  }

  void saveOrder() async {
    if (validateForm()) {
      print('valid form');
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('user id: ' + prefs.get('uid').toString());

        order.userId = prefs.get('uid');
      } catch (err) {
        print(err);
      }

      locator<NavigationService>().navigateTo(
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
      var res = await locator<OrderService>().postOrder(o);
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
    notifyListeners();
  }

  void removeLastDropPoint() {
    order.dropPoint.removeLast();
    notifyListeners();
  }

  void addDropPoint() {
    order.dropPoint.add(new DropPoint());
    notifyListeners();
  }

  void nameFieldOnSave(String value) {
    order.name = value;
  }

  void weightFieldOnSave(String value) {
    order.weight = double.parse(value);
  }

  void pickAddressFieldOnChanged(String value) {
    order.address = value;
  }

  void pickContactFieldOnSave(String value) {
    order.contact = value.substring(4);
  }

  void pickCommentFieldOnSave(String value) {
    order.comment = value;
  }

  void notifySenderOnChanged(_) {
    order.notifyMebySMS = !order.notifyMebySMS;
    notifyListeners();
  }

  void notifyRecipientOnChanged(_) {
    order.notifyRecipientbySMS = !order.notifyRecipientbySMS;
    notifyListeners();
  }
}
