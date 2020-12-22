import 'dart:convert';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:delivery_app/widgets/OrderList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class CompletedOrder extends StatefulWidget {
  @override
  _CompletedOrderState createState() => _CompletedOrderState();
}

class _CompletedOrderState extends State<CompletedOrder> {
  final OrderService orderService = OrderService();
  int _count = 0;
  List<OrderModel> _orders;

  Future<List<OrderModel>> fetchCompletedOrder() async {
    try {
      var res = await orderService.getCompletedOrders();
      if (res == null) throw Exception('failed to fetch completed order');

      if (res.statusCode == 200) {
        List<dynamic> body = json.decode(res.body);

        return body.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      header: DeliveryHeader(
        backgroundColor: Colors.grey[100],
      ),
      firstRefresh: true,
      firstRefreshWidget: Container(
        child: const Center(
          child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Constant.primaryColor)),
        ),
      ),
      onRefresh: () async {
        _orders = await fetchCompletedOrder();
        if (_orders == null) return;

        if (mounted) {
          setState(() {
            _count = _orders.length;
          });
        }
      },
      onLoad: null,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return OrderList(order: _orders[index]);
            },
            childCount: _count,
          ),
        ),
      ],
      emptyWidget: (_orders == null || _orders.length == 0)
          ? Container(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Expanded(
                    child: SizedBox(),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 50.0,
                    height: 60.0,
                    child: Icon(
                      Icons.assignment,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    'No completed order at the moment',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[400]),
                  ),
                  const Expanded(
                    child: SizedBox(),
                    flex: 3,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
