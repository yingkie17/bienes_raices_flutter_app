// To parse this JSON data, do
//
//     final reports = reportsFromJson(jsonString);

import 'dart:convert';

Reports reportsFromJson(String str) => Reports.fromJson(json.decode(str));

String reportsToJson(Reports data) => json.encode(data.toJson());

class Reports {
  String id;
  String nameReport;
  String descriptionReport;
  String dateReport;
  List<Reports> toList = [];

  Reports({
    this.id,
    this.nameReport,
    this.descriptionReport,
    this.dateReport,
  });

  factory Reports.fromJson(Map<String, dynamic> json) => Reports(
        id: json["id"] is int && json["id"] != null
            ? json["id"].toString()
            : json["id"],
        nameReport: json["name_report"],
        descriptionReport: json["description_report"],
        dateReport: json["created_at"],
      );

  Reports.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return; //si es nulo no lo va ejecutar
    jsonList.forEach((item) {
      Reports reports = Reports.fromJson(item);
      toList.add(reports);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_report": nameReport,
        "description_report": descriptionReport,
        "created_at": dateReport,
      };

  static bool isInteger(num value) =>
      value is int || value == value.roundToDouble();
}
