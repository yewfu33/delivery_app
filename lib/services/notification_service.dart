import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants.dart';

class NotificationService {
  static final NotificationService _singleton = NotificationService._init();

  // register sigleton instance
  factory NotificationService() => _singleton;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool _initialized = false;

  NotificationService._init() {
    init();
  }

  Future<void> init() async {
    configure();
    initLocalNotifications();

    if (!_initialized) {
      final String fcmToken = await _fcm.getToken();

      print("Fcm token : $fcmToken");

      _initialized = true;
    }
  }

  Future getFcmToken() async {
    return _fcm.getToken();
  }

  void initLocalNotifications() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = IOSInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void configure() {
    _fcm.configure(
      onBackgroundMessage: myBackgroundMessageHandler,
      // this callback is used when the app runs on the foreground
      onMessage: handleOnMessage,
      // used when the app is closed completely and is launched using the notification
      onLaunch: handleOnLaunch,
      // when its on the background and opened using the notification drawer
      onResume: handleOnResume,
    );
  }

  Future handleOnMessage(Map<String, dynamic> message) async {
    try {
      print("=== data:onmessage = ${message.toString()}");
      print("myBackgroundMessageHandler message: $message");
      final msgId = int.tryParse(message["data"]["id"].toString()) ?? 0;
      print("msgId $msgId");

      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.max,
        priority: Priority.high,
      );

      const iOSPlatformChannelSpecifics = IOSNotificationDetails();

      const platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      flutterLocalNotificationsPlugin.show(
        msgId,
        message["notification"]["title"] as String,
        message["notification"]["body"] as String,
        platformChannelSpecifics,
      );
    } catch (e) {
      print(e);
    }

    return Future<void>.value();
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }

  static Future myBackgroundMessageHandler(Map<String, dynamic> message) async {
    print("myBackgroundMessageHandler message: $message");
  }
}
