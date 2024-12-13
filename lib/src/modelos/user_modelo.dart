// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:bienes_raices_app/src/modelos/rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String name;
  String lastname;
  String identity_card;
  String email;
  String phone;
  String address_agent;
  String date_of_birth;
  String place_of_birth;
  String password;
  String image;
  String experience;
  String certificates;
  String area_specialist;
  String date_of_entry;
  String sessionToken;
  List<Rol> roles = [];
  List<User> toList = [];

  User(
      {this.id,
      this.name,
      this.lastname,
      this.identity_card,
      this.email,
      this.phone,
      this.address_agent,
      this.date_of_birth,
      this.place_of_birth,
      this.password,
      this.image,
      this.experience,
      this.certificates,
      this.area_specialist,
      this.date_of_entry,
      this.sessionToken,
      this.roles});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] is int ? json['id'].toString() : json["id"],
        name: json["name"],
        lastname: json["lastname"],
        identity_card: json["identity_card"],
        email: json["email"],
        phone: json["phone"],
        address_agent: json["address_agent"],
        date_of_birth: json["date_of_birth"],
        place_of_birth: json["place_of_birth"],
        password: json["password"],
        image: json["image"],
        experience: json["experience"],
        certificates: json["certificates"],
        area_specialist: json["area_specialist"],
        date_of_entry: json["date_of_entry"],
        sessionToken: json["session_token"],
        roles: json["roles"] == null
            ? []
            : List<Rol>.from(
                    json['roles'].map((model) => Rol.fromJson(model))) ??
                [],
      );

  User.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      User user = User.fromJson(item);
      toList.add(user);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "identity_card": identity_card,
        "email": email,
        "phone": phone,
        "address_agent": address_agent,
        "date_of_birth": date_of_birth,
        "place_of_birth": place_of_birth,
        "password": password,
        "image": image,
        "experience": experience,
        "certificates": certificates,
        "area_specialist": area_specialist,
        "date_of_entry": date_of_entry,
        "session_token": sessionToken,
        "roles": roles,
      };
}
