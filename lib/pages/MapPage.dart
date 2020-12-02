import 'dart:async';

import 'package:delivery_app/locator.dart';
import 'package:delivery_app/services/tracking_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  static final CameraPosition initPosition = CameraPosition(
    target: LatLng(1.554700, 103.594063),
    zoom: 16,
  );

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  StreamSubscription _subscription;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;

  void addMarker(double lat, double lon) {
    // marker id
    final String markerIdVal = 'marker_$_markerIdCounter';
    // increment the marker
    _markerIdCounter += 1;

    final MarkerId markerId = MarkerId(markerIdVal);

    // create marker instance
    final Marker marker = Marker(
      markerId: MarkerId(markerIdVal),
      position: LatLng(lat, lon),
    );

    // animate the camera

    _controller.future.then((c) =>
        c.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lon), 16)));

    print('added marker: $markerIdVal');

    // populate state
    setState(() {
      markers.clear();
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    _controller.future.then((_) {
      _subscription = locator<TrackingService>().trackingStream.listen((d) {
        addMarker(d.latitude, d.longitude);
      });
    });
    super.initState();
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
        title: Text('Track order'),
        leading: BackButton(),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: MapPage.initPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values),
        ),
      ),
    );
  }
}
