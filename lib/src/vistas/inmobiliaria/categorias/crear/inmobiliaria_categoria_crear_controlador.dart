import 'package:bienes_raices_app/id_reports/id_reports.dart';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/categoria_model.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/categoria_provider.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class InmobiliariaCategoriaCrearControlador {
  BuildContext context;
  Function refresh;
  TextEditingController nombreCategoriaController = new TextEditingController();
  TextEditingController descripcionCategoriaController =
      new TextEditingController();
  ReporteProvider _reporteProvider = new ReporteProvider();
  ReportsHasReports reportsHasReports;
  CategoriaProvider _categoriaProvider = new CategoriaProvider();
  User user;
  String idUserAgente;

  Idreports _idreports = new Idreports();
  SharedPref sharedPref = new SharedPref();
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    _categoriaProvider.init(context, user);
    _reporteProvider.init(context, user);
    idUserAgente = user.id;
  }

  void crearCategoria() async {
    String nombreCategoria = nombreCategoriaController.text;
    String desripcionCategoria = descripcionCategoriaController.text;

    if (nombreCategoria.isEmpty || desripcionCategoria.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe ingresar todos los campos'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));

      return;
    }
    Category category =
        new Category(name: nombreCategoria, description: desripcionCategoria);
    ResponseApi responseApi = await _categoriaProvider.create(category);

    if (responseApi.success) {
      ReportsHasReports reportsHasReports = ReportsHasReports(
        idReports:
            '${_idreports.idReportCrearCategoria.toString()}', // ID del tipo de reporte para actualización de producto
        idUser: null,
        idAgent: '${idUserAgente}',
        nameReport: 'Creación de Categoria',
        descriptionReport:
            'Se creó una nueva categoria por el Agente: ${user.name},\n ${user.lastname},\n Id: $idUserAgente,\n celular: ${user.phone}, E-mail: ${user.email},\n\n=== Datos categoría ===\n\n Id categoría ${category.id},\n Nombre de la categoría: ${category.name},\n Descripción categoría: ${category.description}',
      );

      ResponseApi reportResponse =
          await _reporteProvider.addReport(reportsHasReports);
      if (reportResponse.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Se ha generado un reporte de creación de nueva categoría'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.lightGreen[900],
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Error al generar el reporte de la actualización del producto'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
      }
      nombreCategoriaController.text = '';
      descripcionCategoriaController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${responseApi.message}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen[900],
      ));
      // Cerrar la pantalla actual después de 2 segundos
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, true);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${responseApi.message}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
    }
  }
}
