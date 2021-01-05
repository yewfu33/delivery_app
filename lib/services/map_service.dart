import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:http/http.dart' as http;

class MapService {
  Future<int> getDistancesByCoordinates(LatLng l1, LatLng l2) async {
    try {
      final apikey = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

      final String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apikey";
      final http.Response response = await http.get(url);

      final Map values = jsonDecode(response.body) as Map;

      final int distance =
          values["routes"][0]["legs"][0]["distance"]["value"] as int;

      return distance;
    } catch (e) {
      rethrow;
    }
  }
}
