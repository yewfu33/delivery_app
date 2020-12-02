import 'package:flutter/material.dart';

class DropPoint {
  int dropPointId;
  String address = '';
  double latitude = 0;
  double longitude = 0;
  String contact;
  DateTime dateTime = DateTime.now();
  String comment = '';
  TextEditingController phoneFieldController =
      new TextEditingController(text: '+60 ');
  TextEditingController addressFieldController = new TextEditingController();
  TextEditingController dateTimeFieldController = new TextEditingController();

  Map toMap() => {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'contact_num': contact,
        'datetime': dateTime,
        'comment': comment,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
      };
}
