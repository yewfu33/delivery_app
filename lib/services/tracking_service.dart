import 'dart:async';
import 'dart:io';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/courierslocation.dart';
import 'package:signalr_client/errors.dart';
import 'package:signalr_client/signalr_client.dart';

class TrackingService {
  // HubConnection instance
  HubConnection hubConnection;

  // The location of the SignalR Server.
  final String serverUrl = "${Constant.serverName}${Constant.hub}";

  final hubMethodName = "CourierLocation";

  // traking use stream
  StreamController<CouriersLocation> _trackingController =
      StreamController<CouriersLocation>.broadcast();

  Stream<CouriersLocation> get trackingStream => _trackingController.stream;

  TrackingService.init(String uid) {
    // Creates the connection by using the HubConnectionBuilder.
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();

    // When the connection is closed, print out a message to the console.
    hubConnection.onclose(
        (error) => print("Connection Closed, err: " + error.toString()));

    hubConnection.on("OnHubConnected", (List<Object> parameters) {
      print('${parameters[0]}');
    });

    hubConnection.on(hubMethodName, (List<Object> parameters) {
      print(
          'On listen \"CouriersLocation\" hub, ${parameters[0].toString()} | ${parameters[1].toString()}');

      // add couriers location to a listenable stream
      _trackingController.add(new CouriersLocation(
          latitude: parameters[0], longitude: parameters[1]));
    });

    try {
      hubConnection.start().then((_) {
        hubConnection.invoke("registerConnectionId", args: <Object>[uid]);
      }).catchError((e) => throw e);
    } on SocketException catch (e) {
      print("socket exception in \"hub start\" ${e.toString()}");
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
    } on GeneralError catch (e) {
      print('error in send. ' + e.toString());
    } catch (e) {
      print('error in send, ' + e.toString());
    }
  }
}
