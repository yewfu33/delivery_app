import 'dart:async';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/courierslocation.dart';
import 'package:signalr_client/signalr_client.dart';

class TrackingService {
  // HubConnection instance
  HubConnection hubConnection;

  // The location of the SignalR Server.
  final String serverUrl = "${Constant.serverName}${Constant.hub}";

  final hubMethodName = "CourierLocation";

  // traking use stream
  final StreamController<CouriersLocation> _trackingController =
      StreamController<CouriersLocation>.broadcast();

  Stream<CouriersLocation> get trackingStream => _trackingController.stream;

  TrackingService.init(int uid) {
    // Creates the connection by using the HubConnectionBuilder.
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();

    // When the connection is closed, print out a message to the console.
    hubConnection.onclose((error) => print("Connection Closed, err: $error"));

    hubConnection.on("OnHubConnected", (List<Object> parameters) {
      print('${parameters[0]}');
    });

    hubConnection.on(hubMethodName, (List<Object> parameters) {
      // add couriers location to a listenable stream
      _trackingController.add(CouriersLocation(
          latitude: parameters[0] as double,
          longitude: parameters[1] as double));
    });

    try {
      hubConnection.start().then((_) {
        hubConnection.invoke("registerConnectionId", args: <Object>[uid]);
      }).catchError((e) => throw e);
    } catch (e) {
      print(e.toString());
    }
  }

  void off() {
    hubConnection.off(hubMethodName);
  }

  void invoke(String methodName, CouriersLocation location) {
    try {
      // null safety
      if (hubConnection == null) return;

      hubConnection.invoke(methodName, args: <Object>[
        location.latitude,
        location.longitude,
      ]);
    } catch (e) {
      print('error in send, $e');
    }
  }
}
