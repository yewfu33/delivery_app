import 'package:delivery_app/services/account_service.dart';
import 'package:delivery_app/services/dialog_service.dart';
import 'package:delivery_app/services/location_service.dart';
import 'package:delivery_app/services/navigation_service.dart';
import 'package:delivery_app/services/notification_service.dart';
import 'package:delivery_app/services/order_service.dart';
import 'package:delivery_app/services/tracking_service.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(NavigationService());
  locator.registerSingleton(TrackingService());
  locator.registerSingleton(NotificationService.init());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AccountService());
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => LocationService());
}
