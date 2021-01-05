import 'dart:async';

import 'package:delivery_app/models/courierslocation.dart';
import 'package:delivery_app/models/uiModels/order_model.dart';
import 'package:delivery_app/services/tracking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  final OrderModel order;

  const MapPage({Key key, @required this.order}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  TrackingService trackingService;
  GoogleMapController _controller;
  StreamSubscription _subscription;
  final Set<Marker> _markers = {};
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
    _controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lon), 18));

    // populate state
    setState(() {
      _markers.clear();
      _markers.add(marker);
    });
  }

  final mockLocation = [
    CouriersLocation(latitude: 1.554700, longitude: 103.594063),
    CouriersLocation(latitude: 1.554053, longitude: 103.591690),
    CouriersLocation(latitude: 1.553345, longitude: 103.589972),
    CouriersLocation(latitude: 1.560295, longitude: 103.586430),
    CouriersLocation(latitude: 1.557373, longitude: 103.583888),
    CouriersLocation(latitude: 1.565250, longitude: 103.583105),
    CouriersLocation(latitude: 1.542835, longitude: 103.577526),
    CouriersLocation(latitude: 1.539017, longitude: 103.577612),
  ];

  Stream<CouriersLocation> mockLocationStream() async* {
    for (final l in mockLocation) {
      yield l;
    }
  }

  @override
  void initState() {
    super.initState();
    prefs.then((p) {
      final uid = p.getInt("uid");
      trackingService = TrackingService.init(uid);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _subscription = trackingService.trackingStream.listen((l) {
          if (mounted) {
            print("uid =${l.latitude} ${l.longitude}");
            addMarker(l.latitude, l.longitude);
          }
        });
      });
    });
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track order'),
        leading: const BackButton(),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.order.latitude, widget.order.longitude),
            zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: _markers,
      ),
    );
  }
}
