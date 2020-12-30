import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'MyInputDecoration.dart';

class WeightField extends StatelessWidget {
  WeightField({
    Key key,
    @required this.model,
  }) : super(key: key);

  final Map weightSelect = <String, double>{
    'Less than 10KG': 0,
    'More than 10KG': 10,
    'More than 50KG': 50,
  };

  final AddOrderViewModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: DropdownButtonFormField(
        validator: (value) => value == null ? 'This field is required' : null,
        decoration: InputDecoration(
          labelText: 'Total weight',
          labelStyle: customInputStyle(),
          contentPadding: EdgeInsets.zero,
        ),
        onTap: () {
          // bring down the keyboard
          FocusScope.of(context).unfocus();
        },
        items: [
          for (var i in weightSelect.entries)
            DropdownMenuItem<double>(
              child: Text(i.key),
              value: i.value,
              key: Key(i.key),
            )
        ],
        onChanged: (v) {
          if (v >= 10 && model.order.vehicleType < 1) {
            showDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: Colors.black.withOpacity(0.5),
              builder: (_) {
                return AlertDialog(
                  title: Text("Alert"),
                  content: Text(
                      "If your item weight is 10KG or above consider a car couriers"),
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
            return;
          } else {
            model.order.weight = v;
          }
        },
      ),
    );
  }
}
