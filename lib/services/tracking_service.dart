import 'dart:async';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/courierslocation.dart';
import 'package:signalr_client/signalr_client.dart';

class TrackingService {
  // HubConnection instance
  HubConnection _hubConnection;

  // The location of the SignalR Server.
  final String _serverUrl = "${Constant.serverName}${Constant.hub}";

  final _hubMethodName = "CourierLocation";

  // traking use stream
  final StreamController<CouriersLocation> _trackingController =
      StreamController<CouriersLocation>.broadcast();

  Stream<CouriersLocation> get trackingStream => _trackingController.stream;

  TrackingService.init(int uid) {
    // Creates the connection by using the HubConnectionBuilder.
    _hubConnection = HubConnectionBuilder().withUrl(_serverUrl).build();

    // When the connection is closed, print out a message to the console.
    _hubConnection.onclose((error) => print("Connection Closed, err: $error"));

    _hubConnection.on("OnHubConnected", (List<Object> parameters) {
      print('${parameters[0]}');
    });

    _hubConnection.on(_hubMethodName, (List<Object> parameters) {
      // add couriers location to a listenable stream
      _trackingController.add(CouriersLocation(
          latitude: parameters[0] as double,
          longitude: parameters[1] as double));
    });

    try {
      _hubConnection.start().then((_) {
        _hubConnection.invoke("registerConnectionId", args: <Object>[uid]);
      }).catchError((e) => throw e);
    } catch (e) {
      print(e.toString());
    }
  }

  void off() {
    _hubConnection.off(_hubMethodName);
  }

  void invoke(String methodName, CouriersLocation location) {
    try {
      // null safety
      if (_hubConnection == null) return;

      _hubConnection.invoke(methodName, args: <Object>[
        location.latitude,
        location.longitude,
      ]);
    } catch (e) {
      print('error in send, $e');
    }
  }
}
