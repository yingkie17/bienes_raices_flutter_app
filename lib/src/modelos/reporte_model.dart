// To parse this JSON data, do
//
//     final reportsHasReports = reportsHasReportsFromJson(jsonString);

import 'dart:convert';

import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/reportes_moldel.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';

ReportsHasReports reportsHasReportsFromJson(String str) =>
    ReportsHasReports.fromJson(json.decode(str));

String reportsHasReportsToJson(ReportsHasReports data) =>
    json.encode(data.toJson());

class ReportsHasReports {
  String id;
  String idReports;
  String idUser;
  String idAgent;
  String idProduct;
  String nameReport;
  String descriptionReport;
  String statusReport;
  String dateReport;
  String year;
  User agent;
  User client;
  Product product;
  Reports categoryReport;
  Reports typeReports;
  List<ReportsHasReports> toList = [];

  ReportsHasReports(
      {this.id,
      this.idReports,
      this.idUser,
      this.idAgent,
      this.idProduct,
      this.nameReport,
      this.descriptionReport,
      this.statusReport,
      this.dateReport,
      this.year,
      this.product,
      this.agent,
      this.client,
      this.categoryReport});

  factory ReportsHasReports.fromJson(Map<String, dynamic> json) =>
      ReportsHasReports(
        id: json["id"] is int ? json["id"].toString() : (json["id"] ?? ""),
        idReports: json["idReport"] is int
            ? json["idReport"].toString()
            : (json["idReport"] ?? ""),
        idUser: json["id_user"] is int
            ? json["id_user"].toString()
            : (json["id_user"] ?? ""),
        idAgent: json["id_agent"] is int
            ? json["id_agent"].toString()
            : (json["id_agent"] ?? ""),
        idProduct: json["id_product"] is int
            ? json["id_product"].toString()
            : (json["id_product"] ?? "No Disponible"),
        nameReport: json["name_report"],
        descriptionReport: json["description_report"],
        statusReport: json["status_report"],
        dateReport: json["created_at"] != null
            ? json["created_at"].toString()
            : "No Disponible",
        year: json["year"] != null
            ? json["year"].toString()
            : "No se obtuvo ningún año de reportes",
        agent: json["agent"] != null ? User.fromJson(json["agent"]) : null,
        client: json["client"] != null ? User.fromJson(json["client"]) : null,
        product:
            json["product"] != null ? Product.fromJson(json["product"]) : null,
        categoryReport: json["category_report"] != null
            ? Reports.fromJson(json["category_report"])
            : null,
      );

  ReportsHasReports.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      ReportsHasReports reports_has_report = ReportsHasReports.fromJson(item);
      toList.add(reports_has_report);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_reports": idReports,
        "id_user": idUser,
        "id_agent": idAgent,
        "id_product": idProduct,
        "name_report": nameReport,
        "description_report": descriptionReport,
        "status_report": statusReport,
        "created_at": dateReport,
        "year": year,
        "category_report": categoryReport,
        "product": product,
        "agent": agent,
        "client": client,
      };

  static bool isInteger(num value) =>
      value is int || value == value.roundToDouble();
}
