import 'package:delivery_app/locator.dart';
import 'package:delivery_app/pages/MapPage.dart';
import 'package:delivery_app/services/location_service.dart';
import 'package:delivery_app/services/tracking_service.dart';
import 'package:delivery_app/views/activeorder_view.dart';
import 'package:delivery_app/constants.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  final TrackingService trackingService = locator<TrackingService>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Constant.primaryColor,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Active',
                  style: const TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Completed',
                  style: const TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Tab(
                child: Text(
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
            // TestingAddedWidget(),
            Container(),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}

class TestingAddedWidget extends StatelessWidget {
  const TestingAddedWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Icon(Icons.directions_transit),
        RaisedButton(
          onPressed: () async {
            LocationService locationService = locator<LocationService>();
            locationService.startListenLocationChange();
          },
          child: Text('location service'),
        ),
        StreamBuilder(
            stream: locator<LocationService>().locationStream.distinct(),
            builder: (BuildContext context, AsyncSnapshot snapShot) {
              Widget text;
              if (snapShot.hasData) {
                text = Text(
                    '${snapShot.data.latitude} , ${snapShot.data.longitude}');
              } else {
                text = Text('waiting');
              }
              return text;
            }),
        RaisedButton(
          onPressed: () {
            locator<LocationService>().cancelStream();
          },
          child: Text('cancel location service'),
        ),
        RaisedButton(
          onPressed: () {
            locator<TrackingService>().off();
          },
          child: Text('off'),
        ),
        RaisedButton(
          onPressed: () {
            // locator<LocationService>().resumeStream();
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MapPage()));
          },
          child: Text('map'),
        ),
      ],
    );
  }
}
