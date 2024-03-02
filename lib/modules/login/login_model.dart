class LoginModel {
  String? message;
  String? token;
  UserData? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    token = json["token"];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
}

class UserData {
  String? id;
  String? userName;
  String? accountId;
  String? fullName;
  String? email;
  String? photo;
  String? bio;
  List<dynamic>? sentences;
  String? provider;
  int? v;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    userName = json["userName"];
    accountId = json["accountId"];
    fullName = json["fullName"];
    email = json["email"];
    photo = json["photo"];
    bio = json["bio"];
    sentences = json["sentences"];
    provider = json["provider"];
    v = json["__v"];
  }
}
