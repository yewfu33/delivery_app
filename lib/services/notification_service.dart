import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  bool _initialized = false;

  NotificationService.init() {
    this.init();
  }

  Future<void> init() async {
    this.configure();

    if (!_initialized) {
      String fcmToken = await _fcm.getToken();

      print("Fcm token : $fcmToken");

      _initialized = true;
    }
  }

  void configure() {
    _fcm.configure(
      // this callback is used when the app runs on the foreground
      onMessage: handleOnMessage,
      // used when the app is closed completely and is launched using the notification
      onLaunch: handleOnLaunch,
      // when its on the background and opened using the notification drawer
      onResume: handleOnResume,
    );
  }

  Future handleOnMessage(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }
}
