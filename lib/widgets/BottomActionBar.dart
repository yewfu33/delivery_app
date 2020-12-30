import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class BottomActionBar extends StatelessWidget {
  final Function callBack;
  const BottomActionBar({Key key, @required this.callBack}) : super(key: key);

  void showPricingDetail(
      BuildContext context, double distance, double price, double discount) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Constant.primaryColor,
          ),
        ),
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Distance"),
                  Text("${distance.round()} KM"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Delivery Fee"),
                  Text("RM $price"),
                ],
              ),
              const SizedBox(height: 10),
              if (discount != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Promo Code"),
                    Text("-$discount"),
                  ],
                ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(_).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = context.select((AddOrderViewModel model) => model.order);
    final distance =
        context.select((AddOrderViewModel model) => model.distance);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              showPricingDetail(
                  context, distance, order.solidPrice, order.discount);
            },
            child: Container(
              child: Row(
                children: [
                  Text(
                    'RM ${order.price} ',
                    style: const TextStyle(
                      color: Constant.primaryColor,
                      fontSize: 20.0,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.help_outline, size: 18, color: Colors.grey),
                ],
              ),
            ),
          ),
          Spacer(),
          RaisedButton(
            onPressed: () {
              callBack();
            },
            color: Constant.primaryColor,
            textColor: Colors.white,
            child: Text(
              'CREATE ORDER',
              style: const TextStyle(fontSize: 15.0, letterSpacing: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
