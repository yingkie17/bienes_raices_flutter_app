import 'dart:convert';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/reportes_moldel.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReporteProvider {
  String _url = Entorno.API_BIENESRAICES;
  String _api = '/api/reports';

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  //Método para obtener la lista de tipos de reportes

  Future<List<Reports>> getAllReports() async {
    try {
      Uri uri = Uri.http(_url, '$_api/getAllReports');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }
      final List<dynamic> data = json.decode(res.body);
      List<Reports> reportsList =
          data.map((item) => Reports.fromJson(item)).toList();
      // Cambia "date" por el campo que deseas ordenar
      return reportsList;
    } catch (error) {
      print(
          'Se Produjo un error en el método obtener lista de tipo de Reportes: $error');
      return [];
    }
  }

  //Método para generar un reporte del lado del agente
  Future<ResponseApi> addReport(ReportsHasReports reportsHasReports) async {
    try {
      Uri uri = Uri.http(_url, '$_api/addReport');
      String bodyParams = json.encode(reportsHasReports.toJson());
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.post(uri, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en categoria_provider en el método create,  Error: $error');

      return null;
    }
  }

  //Método para generar un reporte de lado de cliente
  Future<ResponseApi> addReportClient(
      ReportsHasReports reportsHasReports) async {
    try {
      Uri uri = Uri.http(_url, '$_api/addReportClient');
      String bodyParams = json.encode(reportsHasReports.toJson());
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.post(uri, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en categoria_provider en el método create,  Error: $error');

      return null;
    }
  }

  //Método para crear reporte de registro de cliente
  Future<ResponseApi> addReportRegisterClient(
      ReportsHasReports reportsHasReports) async {
    try {
      Uri uri = Uri.http(_url, '$_api/addReportRegisterClient');
      String bodyParams = json.encode(reportsHasReports.toJson());
      Map<String, String> headers = {
        'Content-type': 'application/json',
      };
      final res = await http.post(uri, headers: headers, body: bodyParams);

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en reporte_nuevo_usuario_provider en el método addReportRegisterClient,  Error: $error');

      return null;
    }
  }

//Método para Obtener Lista de todos los reportes según el tipo de reporte

  //Método para obtener la lista de todas los reportes de agente
  Future<List<ReportsHasReports>> getByTypeReport(String id_reports) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findByTypeReport/$id_reports');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
        return [];
      }

      final data = json.decode(res.body);

      if (!data['success']) {
        // Si el servidor devuelve un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${data['message']}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
        return [];
      }

      ReportsHasReports reports_has_report =
          ReportsHasReports.fromJsonList(data['reports']);

      return reports_has_report.toList;
    } catch (error) {
      print(
          'Se produjo un error en el método para obtener lista de todos los reportes de inmobiliaria (Provider), Error: $error');
      return [];
    }
  }

//Obtener el tipo de Reporte de agente inmobiliario para obtener en una lista
  Future<List<Reports>> getAllReportsByTypeAgent() async {
    try {
      Uri uri = Uri.http(_url, '$_api/findAgentReportByType');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }
      //Aca se obtenie el tipo de reporte
      final data = json.decode(res.body);
      Reports reports = Reports.fromJsonList(data);
      return reports.toList;
    } catch (error) {
      print(
          'Se Produjo un error en el método obtener lista de tipos de reportes, Error: $error');
      return [];
    }
  }

//Método para obtener la lista de años en los que existe reportes del agente

  Future<List<ReportsHasReports>> getReportYears() async {
    try {
      Uri uri = Uri.http(_url, '$_api/getReportYears');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      ReportsHasReports reports_has_report =
          ReportsHasReports.fromJsonList(data);
      return reports_has_report.toList;
    } catch (error) {
      print(
          'Se produjo un error en el método obtener lista años en los que existen reportes, Error: $error');
      return [];
    }
  }

//Métedo para listar los reportes de agente inmobiliario

  Future<List<ReportsHasReports>> getAgentReportByPeriod(
      String getAgentReport) async {
    try {
      Uri uri = Uri.http(
          _url, '$_api/getAgentReportsByTypeAndStartEndPeriod/$getAgentReport');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
        return [];
      }

      final data = json.decode(res.body);

      if (!data['success']) {
        // Si el servidor devuelve un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${data['message']}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
        return [];
      }

      ReportsHasReports reports_has_report =
          ReportsHasReports.fromJsonList(data['reports']);

      if (reports_has_report.toList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${data['message']}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange[800],
        ));
        return [];
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${data['message']}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen[900],
      ));
      return reports_has_report.toList;
    } catch (error) {
      print(
          'Se produjo un error en el método para obtener lista de reportes de agente inmobiliario por periodo de inicio y de finalizacion (Provider), Error: $error');
      return [];
    }
  }
}
