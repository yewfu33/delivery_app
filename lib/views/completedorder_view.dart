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
  ScrollController _scrollController;
  int _count = 0;
  List<OrderModel> _orders;

  Future<List<OrderModel>> fetchCompletedOrder() async {
    try {
      final res = await orderService.getCompletedOrders();
      if (res == null) throw Exception('failed to fetch completed order');

      if (res.statusCode == 200) {
        final List body = json.decode(res.body) as List;

        return body
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      header: DeliveryHeader(
        backgroundColor: Colors.grey[100],
      ),
      scrollController: _scrollController,
      firstRefresh: true,
      firstRefreshWidget: const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Constant.primaryColor)),
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
      emptyWidget: (_orders == null || _orders.isEmpty)
          ? SizedBox(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
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
                    flex: 3,
                    child: SizedBox(),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
