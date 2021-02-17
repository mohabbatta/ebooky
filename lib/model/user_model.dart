// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.userName,
    this.password,
  });

  int id;
  String userName;
  String password;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    userName: json["userName"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userName": userName,
    "password": password,
  };
}
