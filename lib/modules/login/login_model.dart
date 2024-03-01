class LoginModel {
  String? message;
  String? token;

  UserData? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    token = json["token"];
    data = UserData.fromJson(json["data"]);
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

  UserData.fromJson(Map<String, dynamic> jason) {
    id = jason["_id"];
    userName = jason["userName"];
    accountId = jason["accountId"];
    fullName = jason["fullName"];
    email = jason["email"];
    photo = jason["photo"];
    bio = jason["bio"];
    sentences = jason["sentences"];
    provider = jason["provider"];
    v = jason["__v"];
  }
}
