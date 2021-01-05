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
  get price => (_basePrice + _price);
  double _solidPrice = 0;
  get solidPrice => _solidPrice;
  double _discount = 0;
  get discount => _discount;

  String promoCode = "";
  int promoCodeId = 0;

  //default status = 0 -> active
  int status = 0;
  int userId;
  bool notifyMebySMS = false;
  bool notifyRecipientbySMS = false;
  DateTime createdAt;
  List<DropPoint> dropPoint = <DropPoint>[
    new DropPoint(),
  ];

  final double _basePrice = 4.0;
  final double _pricePerKM = 2;

  set setDiscountValue(double d) {
    this._discount = d;
  }

  void calculatePriceFromDistance(int distanceInMeter) {
    double distanceInKM = distanceInMeter / 1000;
    if (distanceInKM < 1) {
      this._solidPrice = this._price;
      this._price = this._price;
    } else {
      var p = (distanceInKM * _pricePerKM).roundToDouble();
      this._solidPrice = p + _basePrice;
      this._price = p;
    }
  }

  void applyDiscountIfAny() {
    if (_discount != 0) {
      _price -= _discount;
    }
  }

  void resetPrice() {
    this._price = 0;
  }

  Map toMap() {
    List<Map> dp = this.dropPoint != null
        ? this.dropPoint.map((i) => i.toMap()).toList()
        : null;

    Map m = {
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
