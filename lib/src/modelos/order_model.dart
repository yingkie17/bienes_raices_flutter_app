// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:bienes_raices_app/src/modelos/direccion_modelo.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:http/http.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String id;
  String idClient;
  String idAgent;
  String idAddress;
  String status;
  double lat;
  double lng;
  int timestamp;
  List<Product> products = [];
  List<Order> toList = [];
  User client;
  User agent;
  Address address;

  Order({
    this.id,
    this.idClient,
    this.idAgent,
    this.idAddress,
    this.status,
    this.lat,
    this.lng,
    this.timestamp,
    this.products,
    this.client,
    this.agent,
    this.address,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        idClient: json["id_client"],
        idAgent: json["id_agent"],
        idAddress: json["id_address"] is int
            ? json["id_address"].toString()
            : json["id_address"],
        status: json["status"],
        lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"],
        lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"],
        timestamp: json["timestamp"] is String
            ? int.parse(json["timestamp"])
            : json["timestamp"],
        products: json["products"] != null
            ? List<Product>.from(json["products"].map((model) =>
                    model is Product ? model : Product.fromJson(model))) ??
                []
            : [],
        client: json['client'] is String
            ? userFromJson(json['client'])
            : json['client'] is User
                ? json['client']
                : User.fromJson(json['client'] ?? {}),
        agent: json['agent'] is String
            ? userFromJson(json['agent'])
            : json['agent'] is User
                ? json['agent']
                : User.fromJson(json['agent'] ?? {}),
        address: json['address'] is String
            ? addressFromJson(json['address'])
            : json['address'] is Address
                ? json['address']
                : Address.fromJson(json['address'] ?? {}),
      );

  Order.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Order order = Order.fromJson(item);
      toList.add(order);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_client": idClient,
        "id_agent": idAgent,
        "id_address": idAddress,
        "status": status,
        "lat": lat,
        "lng": lng,
        "timestamp": timestamp,
        "products": products,
        "client": client,
        "agent": agent,
        "address": address,
      };
}
