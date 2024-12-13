import 'package:flutter/material.dart';

import 'dart:async';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/reportes_moldel.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class InmobiliariaEstadiscasController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  User user;
  ReporteProvider _reporteProvider = new ReporteProvider();
  List<Reports> reports = [];

  Timer searchStoppedTyping;

  String nombreReport = '';

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));

    _reporteProvider.init(context, user);

    getAllReports();
    refresh();
  }

  Future<List<ReportsHasReports>> getReports(String id_reports) async {
    return await _reporteProvider.getByTypeReport(id_reports);
  }

  void getAllReports() async {
    reports = await _reporteProvider.getAllReports();
    refresh();
  }

  void goToReportesDetalle(Reports reports) {
    Navigator.pushNamed(context, 'inmobiliaria/reportes/detalle',
        arguments: reports);
  }

  void onChangedText(String text) {
    Duration duration = new Duration(milliseconds: 800);
    if (searchStoppedTyping != null) {
      searchStoppedTyping.cancel();
      refresh();
    }
    searchStoppedTyping = new Timer(duration, () {
      nombreReport = text;
      refresh();

      print('Texto Completo: $nombreReport');
    });
  }

  //Método para obtener la lista de tipo de reportes
  void obtenerTipoReporte() async {
    reports = await _reporteProvider.getAllReports();
    refresh();
  }

//Metodo para formato de fecha

  String formatFechaCreacionReporte(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

/*
  void openBottomSheet(ReportsHasReports reportsHasReports) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientePropiedadesDetallePage(
              reportsHasReports: reportsHasReports,
            ));
  } */

}
