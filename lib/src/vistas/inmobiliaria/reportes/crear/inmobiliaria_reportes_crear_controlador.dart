import 'dart:convert';

import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/reportes_moldel.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class InmobiliariaReportesCrearControlador {
  BuildContext context;
  Function refresh;
  TextEditingController tituloReporteController = new TextEditingController();
  TextEditingController descripcionReporteController =
      new TextEditingController();

  ReporteProvider _reporteProvider = new ReporteProvider();

  User user;
  SharedPref sharedPref = new SharedPref();
  List<Reports> reports = [];
  String idReports;
  String idUser;
  String idUserAgente;
  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = new ProgressDialog(context: context);
    user = User.fromJson(await sharedPref.read('user'));
    _reporteProvider.init(context, user);
    obtenerTipoReporte();
    // Obtener ID del usuario y del tipo de reporte de SharedPreferences
    String usuarioId = await sharedPref.read('id');
    String tipoReporteId = await sharedPref.read('tipo_reporte_id');
    idUser = usuarioId;
    idReports = tipoReporteId;
    idUserAgente = user.id;
  }

  //Método para obtener la lista de tipo de reportes
  void obtenerTipoReporte() async {
    reports = await _reporteProvider.getAllReports();
    refresh();
  }

  //Método para crear reporte

  //Procesando creacion de reporte

  void generarReporte() async {
    String tituloReporte = tituloReporteController.text;
    String descripcionReporte = descripcionReporteController.text;

    if (tituloReporte.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe ingresar el titulo de reporte'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }

    if (idReports == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Seleccione el tipo de reporte'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }

    if (tituloReporte.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe ingresar la descripción de reporte'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }

    ReportsHasReports reportsHasReports = new ReportsHasReports(
        idReports: idReports,
        idUser: null,
        idAgent: '$idUserAgente',
        nameReport: tituloReporte,
        descriptionReport: descripcionReporte);
    ResponseApi responseApi =
        await _reporteProvider.addReport(reportsHasReports);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${responseApi.message}'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.lightGreen[900],
    ));

    if (responseApi.success) {
      tituloReporteController.text = '';
      descripcionReporteController.text = '';
    }
  }
}
