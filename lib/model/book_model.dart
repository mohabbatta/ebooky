
import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(Book data) => json.encode(data.toJson());

class Book {
  Book({
    this.id,
    this.name,
    this.pic,
    this.num,
  });

  int id;
  String name;
  String pic;
  int num;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    name: json["name"],
    pic: json["pic"],
    num: json["num"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "pic": pic,
    "num": num,
  };
}
