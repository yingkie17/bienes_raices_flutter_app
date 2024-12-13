// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  String id;
  String idUser;
  String address;
  String neighborhood;
  double lat;
  double lng;
  TimeOfDay timeEvent;
  DateTime dateEvent;
  List<Address> toList = [];

  Address({
    this.id,
    this.idUser,
    this.address,
    this.neighborhood,
    this.lat,
    this.lng,
    this.timeEvent,
    this.dateEvent,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] is int ? json['id'].toString() : json['id'],
        idUser: json["id_user"],
        address: json["address"],
        neighborhood: json["neighborhood"],
        lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"],
        lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"],
        timeEvent: json["hour_event"] != null
            ? TimeOfDay(
                hour: int.parse(json["hour_event"].split(":")[0]),
                minute: int.parse(json["hour_event"].split(":")[1]),
              )
            : null,
        dateEvent: json["date_event"] != null
            ? DateTime.parse(json["date_event"])
            : DateTime.now(),
      );

  Address.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Address address = Address.fromJson(item);
      toList.add(address);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "address": address,
        "neighborhood": neighborhood,
        "lat": lat,
        "lng": lng,
        "hour_event":
            "${timeEvent.hour.toString().padLeft(2, '0')}:${timeEvent.minute.toString().padLeft(2, '0')}",
        "date_event":
            "${dateEvent.year.toString().padLeft(4, '0')}-${dateEvent.month.toString().padLeft(2, '0')}-${dateEvent.day.toString().padLeft(2, '0')}",
      };
}
