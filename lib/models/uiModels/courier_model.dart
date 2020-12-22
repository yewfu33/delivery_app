class CourierModel {
  final int id;
  final String name;
  final String profilePic;
  final String phoneNum;

  CourierModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        profilePic = json['profile_picture'],
        phoneNum = json['phone_num'];
}
