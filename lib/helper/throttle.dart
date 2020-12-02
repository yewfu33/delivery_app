import 'package:rxdart/rxdart.dart';

final throtller = PublishSubject<Function()>();

Function() throttle(int throttleDurationInSeconds, Function() function) {
  throtller.throttleTime(Duration(seconds: throttleDurationInSeconds)).forEach(
    (f) {
      f();
    },
  );

  return () {
    throtller.add(function);
  };
}
