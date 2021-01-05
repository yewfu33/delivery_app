import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/io_client.dart' as http;

class ApiService {
  final String accountPath = 'api/accounts';
  final String orderPath = 'api/orders';

  // wrap with ioclient to handle connection timeout
  final client = http.IOClient(
      HttpClient()..connectionTimeout = const Duration(seconds: 30));

  Map<String, String> headers = {
    'Content-type': 'application/json',
  };

  Future<String> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return 'Bearer ${prefs.getString('token')}';
  }

  Future<int> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('uid');
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}
