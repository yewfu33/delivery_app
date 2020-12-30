import 'package:delivery_app/views/activeorder_view.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/views/completedorder_view.dart';
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
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
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
