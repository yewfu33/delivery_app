import 'package:delivery_app/models/drop_point.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/services/map_service.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/routes_name.dart' as route;

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

  bool addressesFieldOnChanged() {
    if (order.address.isEmpty) return false;

    for (int i = 0; i < order.dropPoint.length; i++) {
      if (order.dropPoint[i].address.isEmpty) return false;
    }

    calculateOrderPrice();

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

  void calculateOrderPrice() async {
    int distanceInMeter = await this.calculateDistance();
    order.calculatePriceFromDistance(distanceInMeter);

    print('price = ${order.price}');

    // notify changes
    notifyListeners();
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
