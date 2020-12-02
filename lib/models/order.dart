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
  double price = 0;
  //default status
  int status = 0;
  int userId;
  bool notifyMebySMS = false;
  bool notifyRecipientbySMS = true;
  DateTime createdAt;
  List<DropPoint> dropPoint = <DropPoint>[
    new DropPoint(),
  ];

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
      'notify_sender': notifyMebySMS,
      'notify_recipient': notifyRecipientbySMS,
      'created_at': DateTime.now(),
      'updated_at': DateTime.now(),
      'drop_points': dp,
    };

    return m;
  }
}
