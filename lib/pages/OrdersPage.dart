import 'dart:convert';

import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:delivery_app/views/activeorder_view.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/views/completedorder_view.dart';
import 'package:delivery_app/widgets/OrderList.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          actions: [
            // show search page
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                }),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Constant.primaryColor,
            tabs: <Widget>[
              Tab(
                child: const Text(
                  'Active',
                  style: const TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Tab(
                child: const Text(
                  'Completed',
                  style: const TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Tab(
                child: const Text(
                  'Inbox',
                  style: const TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ActiveOrder(),
            CompletedOrder(),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final OrderService orderService = OrderService();

  Future<List<OrderModel>> searchOrderHandler() async {
    try {
      var res = await orderService.searchOrders(query);
      if (res == null) throw Exception('Failed in searching orders');

      if (res.statusCode == 200) {
        List<dynamic> body = json.decode(res.body);

        return body.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed in searching orders');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Stream<List<OrderModel>> getSearchOrders() async* {
    try {
      yield await searchOrderHandler();
    } catch (e) {
      throw e;
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: getSearchOrders(),
      builder: (context, AsyncSnapshot<List<OrderModel>> snapshot) {
        if (snapshot.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Something went wrong")),
            ],
          );
        }
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Constant.primaryColor),
              )),
            ],
          );
        } else if (snapshot.data.length == 0) {
          return Center(
            child: Text(
              "No Results Found.",
            ),
          );
        } else {
          var results = snapshot.data;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return OrderList(order: results[index]);
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
