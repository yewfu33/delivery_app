import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:http/http.dart' as http;

class MapService {
  Future<int> getDistancesByCoordinates(LatLng l1, LatLng l2) async {
    try {
      var apikey = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

      String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apikey";
      http.Response response = await http.get(url);

      Map values = jsonDecode(response.body);

      int distance = values["routes"][0]["legs"][0]["distance"]["value"];

      return distance;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
