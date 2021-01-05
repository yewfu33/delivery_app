class CourierModel {
  final int id;
  final String name;
  final String profilePic;
  final String phoneNum;

  CourierModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        profilePic = json['profile_picture'] as String,
        phoneNum = json['phone_num'] as String;
}
