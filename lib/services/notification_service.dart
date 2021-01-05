import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _singleton = NotificationService._init();

  // register sigleton instance
  factory NotificationService() => _singleton;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  bool _initialized = false;

  NotificationService._init() {
    init();
  }

  Future<void> init() async {
    configure();

    if (!_initialized) {
      final String fcmToken = await _fcm.getToken();

      print("Fcm token : $fcmToken");

      _initialized = true;
    }
  }

  Future getFcmToken() async {
    return _fcm.getToken();
  }

  void configure() {
    _fcm.configure(
      // this callback is used when the app runs on the foreground
      onMessage: handleOnMessage,
      onBackgroundMessage: myBackgroundMessageHandler,
      // used when the app is closed completely and is launched using the notification
      onLaunch: handleOnLaunch,
      // when its on the background and opened using the notification drawer
      onResume: handleOnResume,
    );
  }

  Future handleOnMessage(Map<String, dynamic> data) async {
    print("=== data:onmessage = ${data.toString()}");
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
