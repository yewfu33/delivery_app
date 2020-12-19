import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/services/api_service.dart';
import 'package:http/http.dart' as http;

class OrderService extends ApiService {
  static final OrderService _singleton = OrderService._();

  // register sigleton instance
  factory OrderService() => _singleton;

  OrderService._();

  Future<http.Response> postOrder(Order order) async {
    print(json.encode(order.toMap(), toEncodable: myEncode));
    try {
      return await client.post(
        Constant.serverName + orderPath,
        body: json.encode(order.toMap(), toEncodable: myEncode),
        headers: {
          'Content-type': 'application/json',
          HttpHeaders.authorizationHeader: await getAuthToken(),
        },
      );
    } on SocketException catch (e) {
      print("socket exception in \"postOrder\", " + e.toString());
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<http.Response> getOrderById(int id) async {
    try {
      return await client.get(
        Constant.serverName + orderPath + '/' + id.toString(),
        headers: {
          HttpHeaders.authorizationHeader: await getAuthToken(),
        },
      );
    } on SocketException catch (e) {
      print("socket exception in \"getOrderById\", " + e.toString());
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> getAllOrders() async {
    try {
      return await client.get(
        Constant.serverName + orderPath,
        headers: {
          HttpHeaders.authorizationHeader: await getAuthToken(),
        },
      );
    } on SocketException catch (e) {
      print("socket exception in \"getAllOrders\", " + e.toString());
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> getOrdersByUserId() async {
    try {
      int id = await getUserId();
      return await client.get(
        Constant.serverName + orderPath + '/users/' + id.toString(),
        headers: {
          HttpHeaders.authorizationHeader: await getAuthToken(),
        },
      );
    } on SocketException catch (e) {
      print("socket exception in \"getOrdersByUserId\", " + e.toString());
      return null;
    } catch (e) {
      return null;
    }
  }
}
