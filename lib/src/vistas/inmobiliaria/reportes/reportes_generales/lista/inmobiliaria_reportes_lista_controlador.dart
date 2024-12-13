import 'dart:async';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/reportes_moldel.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/reportes/detalle_reporte/inmobiliaria_reportes_reporte_agente_detalle_page.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';

class InmobiliariaReportesListaController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  User user;
  ReporteProvider _reporteProvider = new ReporteProvider();
  List<Reports> reports = [];
  List<ReportsHasReports> filteredReports = [];
  String id_reports;
  Timer searchStoppedTyping;

  String nombreReport = '';

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    this.id_reports = id_reports;
    user = User.fromJson(await _sharedPref.read('user'));

    _reporteProvider.init(context, user);

    getAllReports();

    refresh();
  }

  Future<List<ReportsHasReports>> getReports(String id_reports) async {
    return filteredReports = await _reporteProvider.getByTypeReport(id_reports);
  }

  void getAllReports() async {
    reports = await _reporteProvider.getAllReports();
    refresh();
  }

  void goToReportDetail(ReportsHasReports reportData) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) =>
            InmobiliariaReportesAgenteDetallePage(reportData: reportData));
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

  void logout() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToPage(String ruta) {
    Navigator.pushNamedAndRemoveUntil(context, ruta, (route) => false);
  }

  void goToOrdesList() {
    Navigator.pushNamed(context, 'cliente/ordenes/list');
  }

  void goToModificarUsuario() {
    Navigator.pushNamed(context, 'cliente/modificar/usuario');
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToCrearCategorias() {
    Navigator.pushNamed(context, 'inmobiliaria/categoria/crear');
  }

  void goToOrderCreatePage() {
    Navigator.pushNamed(context, 'cliente/ordenes/crear');
  }
}
