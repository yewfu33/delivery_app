import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final String newText = '+60 ';

    if (newValue.selection.baseOffset < 4) {
      return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length),
      );
    }

    if (oldValue.text.startsWith('+60 ')) {
      return newValue;
    }

    return newValue;
  }
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

// get order status
String setOrderStatus(int status) {
  switch (status) {
    case 0:
      return 'Active';
      break;
    case 1:
      return 'In Deliver';
      break;
    case 2:
      return 'Completed';
      break;
    case 3:
      return 'Cancelled';
      break;
    default:
      return 'Active';
  }
}

// get vehicle type
String setVehicleType(int type) {
  switch (type) {
    case 0:
      return 'Motorbike';
      break;
    case 1:
      return 'Car';
      break;
    default:
      return 'Motorbike';
  }
}
