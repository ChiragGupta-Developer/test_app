class UserModel {
  String name;
  String headshot;

  UserModel({this.name, this.headshot});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        headshot: json['headshot']
    );
  }
}