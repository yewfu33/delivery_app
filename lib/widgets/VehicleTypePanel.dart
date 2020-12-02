import 'package:delivery_app/constants.dart';
import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleTypePanel extends StatelessWidget {
  const VehicleTypePanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AddOrderViewModel>(context);

    return SizedBox(
      width: double.infinity,
      child: CupertinoSegmentedControl(
        children: {
          0: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Motorbike',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4),
            ),
          ),
          1: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Car',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4),
            ),
          ),
        },
        onValueChanged: (i) {
          model.updateVehicleType(i);
        },
        groupValue: model.order.vehicleType,
        borderColor: primaryColor,
        selectedColor: primaryColor,
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
