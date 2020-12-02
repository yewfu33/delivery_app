import 'dart:async';

import 'package:delivery_app/locator.dart';
import 'package:delivery_app/models/courierslocation.dart';
import 'package:delivery_app/services/tracking_service.dart';
import 'package:location/location.dart';

class LocationService {
  Location _location = Location();

  LocationService();

  StreamController<CouriersLocation> _locationController =
      StreamController<CouriersLocation>.broadcast();

  Stream<CouriersLocation> get locationStream => _locationController.stream;
  Sink<CouriersLocation> get locationSink => _locationController.sink;

  StreamSubscription<LocationData> _locationSubscription;

  Future<PermissionStatus> requestLocationAccess() async {
    // _location.changeSettings(interval: 3000, distanceFilter: 10000);
    var bool = await _location.changeSettings(
      accuracy: LocationAccuracy.balanced,
      interval: 3000,
      //   distanceFilter: 0,
    );
    print('$bool');
    return _location.requestPermission();
  }

  void startListenLocationChange() {
    //

    requestLocationAccess().then((granted) {
      //   if (granted == PermissionStatus.GRANTED) {
      //     _locationSubscription =
      //         _location.onLocationChanged().listen((data) async {
      //       CouriersLocation cl = CouriersLocation(
      //           latitude: data.latitude, longitude: data.longitude);
      //       locationSink.add(cl);
      //       await _emitToListener(cl);
      //     });
      //   }
      if (granted == PermissionStatus.granted) {
        _location.onLocationChanged
            .map((m) =>
                CouriersLocation(latitude: m.latitude, longitude: m.longitude))
            .pipe(_locationController)
            .then((_) => _locationController.close());
      }
    });
  }

  Future _emitToListener(CouriersLocation couriersLocation) async {
    await locator<TrackingService>().send("LatLngToServer", couriersLocation);
  }

  void cancelStream() {
    _locationSubscription.cancel();
  }

  void pauseStream() {
    _locationSubscription.pause();
  }

  void resumeStream() {
    _locationSubscription.resume();
  }
}
