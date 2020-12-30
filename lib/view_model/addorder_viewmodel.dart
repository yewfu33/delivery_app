import 'dart:convert';
import 'package:delivery_app/models/drop_point.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/services/map_service.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/routes_name.dart' as route;
import 'package:http/http.dart' as http;

import '../constants.dart';

class AddOrderViewModel with ChangeNotifier {
  final OrderService orderService = OrderService();
  final MapService mapService = MapService();
  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;
  bool autoValidateForm = false;
  Order order = new Order();

  int _distance = 0;
  double get distance => _distance / 1000;

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

        bool isPassingCorrectDiscount = true;

        if (order.discount != 0) {
          isPassingCorrectDiscount = await applyPromoCode(
              context, order.price, order.promoCode,
              checking: true);

          print("ispassingcorrectdiscount = $isPassingCorrectDiscount");
        }

        if (isPassingCorrectDiscount) {
          Navigator.pushNamed(
            context,
            route.orderConfirmationPage,
            arguments: [
              order,
              createOrder,
            ],
          );
        }
      } catch (err) {
        print(err);
        showResponseDialog(
            context, "Error", "Error create the order, try again later.");
      }
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

  bool addressesFieldOnChanged(BuildContext context) {
    if (order.address.isEmpty) return false;

    for (int i = 0; i < order.dropPoint.length; i++) {
      if (order.dropPoint[i].address.isEmpty) return false;
    }

    calculateOrderPrice(context);

    return true;
  }

  Future calculateDistance() async {
    try {
      // reset distance
      _distance = 0;

      var origin = LatLng(order.latitude, order.longitude);
      var destination = order.dropPoint
          .map<LatLng>((d) => LatLng(d.latitude, d.longitude))
          .toList();

      var d1 =
          await mapService.getDistancesByCoordinates(origin, destination[0]);

      _distance += d1;

      // check dropPoints length
      if (destination.length > 1) {
        for (var i = 0; i < destination.length; i++) {
          if (i % 2 != 0) {
            var d2 = await mapService.getDistancesByCoordinates(
                destination[i - 1], destination[i]);

            _distance += d2;
          }
        }
      }
    } catch (e) {
      print(e);
    }

    return _distance;
  }

  void calculateOrderPrice(BuildContext context) async {
    int distanceInMeter = await this.calculateDistance();
    order.calculatePriceFromDistance(distanceInMeter);

    print('price = ${order.price}');

    if (order.promoCode.isNotEmpty) {
      await applyPromoCode(context, order.price, order.promoCode);
    }

    // notify changes
    notifyListeners();
  }

  Future checkAndApplyPromoCode(
      BuildContext context, double orderFee, String promoCode) async {
    if (order.promoCode.isNotEmpty) {
      showResponseDialog(context, "Failed", "Only once promo code can apply");
      return;
    } else {
      await applyPromoCode(context, orderFee, promoCode);
    }
  }

  Future<bool> applyPromoCode(
      BuildContext context, double orderFee, String promoCode,
      {bool checking = false}) async {
    try {
      final applyPromoCodePath = Constant.serverName + "api/orders/promocode";
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var postBody = {
        "order_fee": orderFee,
        "promo_code": promoCode,
        "user_id": prefs.getInt("uid"),
      };

      http.Response res = await http.post(
        applyPromoCodePath,
        headers: {
          "content-type": "application/json",
          "authorization": "Bearer ${prefs.getString("token")}",
        },
        body: jsonEncode(postBody),
      );

      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);

        if (resBody["discount"] != null && !checking) {
          order.setDiscountValue = resBody["discount"];
          order.applyDiscountIfAny();

          // set order promo code for only one time apply
          order.promoCode = promoCode;

          // notify changes
          notifyListeners();
        }

        if (!checking) {
          showResponseDialog(context, "Success", "Coupon code applied");
        }

        return true;
      } else {
        var resBody = jsonDecode(res.body);
        if (resBody["message"] != null) {
          showResponseDialog(context, "Failed", resBody["message"]);
        } else {
          showResponseDialog(context, "Failed", res.reasonPhrase);
        }

        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void showResponseDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("OK",
                  style: const TextStyle(color: Constant.primaryColor)),
              onPressed: () => Navigator.pop(_),
            ),
          ],
        );
      },
    );
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
