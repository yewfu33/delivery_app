import 'drop_point.dart';

class Order {
  int orderId;
  int vehicleType = 0;
  String name;
  double weight = 0;
  String address = '';
  double latitude = 0;
  double longitude = 0;
  String comment = '';
  String contact;
  DateTime dateTime = DateTime.now();
  double _price = 0;
  double get price => _basePrice + _price;
  double _solidPrice = 0;
  double get solidPrice => _solidPrice;
  double _discount = 0;
  double get discount => _discount;

  String promoCode = "";
  int promoCodeId = 0;

  //default status = 0 -> active
  int status = 0;
  int userId;
  bool notifyMebySMS = false;
  bool notifyRecipientbySMS = false;
  DateTime createdAt;
  List<DropPoint> dropPoint = <DropPoint>[
    DropPoint(),
  ];

  final double _basePrice = 4.0;
  double get basePrice => _basePrice;
  final double _pricePerKM = 2;

  set setDiscountValue(double d) {
    _discount = d;
  }

  void calculatePriceFromDistance(int distanceInMeter) {
    final double distanceInKM = distanceInMeter / 1000;
    if (distanceInKM < 1) {
      _solidPrice = _price;
      _price = _price;
    } else {
      final p = (distanceInKM * _pricePerKM).roundToDouble();
      _solidPrice = p + _basePrice;
      _price = p;
    }
  }

  void applyDiscountIfAny() {
    if (_discount != 0) {
      _price -= _discount;
    }
  }

  void resetPrice() {
    _price = 0;
  }

  Map toMap() {
    List<Map> dp;
    if (dropPoint != null) {
      dp = dropPoint.map((i) => i.toMap()).toList();
    } else {
      dp = null;
    }

    final Map m = {
      'name': name,
      'weight': weight,
      'pick_up_address': address,
      'latitude': latitude,
      'longitude': longitude,
      'comment': comment,
      'contact_num': contact,
      'pick_up_datetime': dateTime,
      'price': price,
      'delivery_status': status,
      'vehicle_type': vehicleType,
      'user_id': userId,
      'promo_code_id': promoCodeId,
      'notify_sender': notifyMebySMS,
      'notify_recipient': notifyRecipientbySMS,
      'created_at': DateTime.now(),
      'updated_at': DateTime.now(),
      'drop_points': dp,
    };

    return m;
  }
}
