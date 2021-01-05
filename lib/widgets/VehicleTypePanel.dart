import 'package:delivery_app/constants.dart';
import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleTypePanel extends StatefulWidget {
  const VehicleTypePanel({
    Key key,
  }) : super(key: key);

  @override
  _VehicleTypePanelState createState() => _VehicleTypePanelState();
}

class _VehicleTypePanelState extends State<VehicleTypePanel> {
  int v = 0;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AddOrderViewModel>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      child: CupertinoSegmentedControl(
        children: const {
          0: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Motorbike',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4),
            ),
          ),
          1: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Car',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4),
            ),
          ),
        },
        onValueChanged: (int i) {
          model.updateVehicleType = i;
          setState(() => v = i);
        },
        groupValue: v,
        borderColor: Constant.primaryColor,
        selectedColor: Constant.primaryColor,
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
