import 'dart:async';

import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/services/tracking_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  final OrderModel order;

  MapPage({Key key, @required this.order}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  TrackingService trackingService;
  GoogleMapController _controller;
  StreamSubscription _subscription;
  Set<Marker> _markers = {};
  int _markerIdCounter = 1;

  void addMarker(double lat, double lon) {
    // marker id
    final String markerIdVal = 'marker_$_markerIdCounter';
    // increment the marker
    _markerIdCounter += 1;

    // create marker instance
    final Marker marker = Marker(
      markerId: MarkerId(markerIdVal),
      position: LatLng(lat, lon),
    );

    // animate the camera
    _controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lon), 16));

    // populate state
    setState(() {
      _markers.clear();
      _markers.add(marker);
    });
  }

  @override
  void initState() {
    super.initState();
    prefs.then((p) {
      var uid = p.getString("uid");
      trackingService = TrackingService.init(uid);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _subscription = trackingService.trackingStream.listen((l) {
          setState(() {
            addMarker(l.latitude, l.longitude);
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track order'),
        leading: const BackButton(),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.order.latitude, widget.order.longitude),
              zoom: 15),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          markers: _markers,
        ),
      ),
    );
  }
}
