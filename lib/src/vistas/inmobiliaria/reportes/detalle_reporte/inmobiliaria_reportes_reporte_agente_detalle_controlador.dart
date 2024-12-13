import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class InmobiliariaReportesAgenteDetalleController {
  BuildContext context;
  Function refrersh;
  User user;
  SharedPref sharedPref = new SharedPref();
  ReporteProvider reporteProvider = new ReporteProvider();
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refrersh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    User sessionUser = User.fromJson(await sharedPref.read('user'));
    if (sessionUser != null) {
      reporteProvider.init(context, user);
    } else {
      // Manejar el caso en el que no se pueda obtener el usuario de la sesión
      print('No se pudo obtener el usuario de la sesión');
      // Aquí podrías mostrar un mensaje de error o realizar alguna otra acción
    }
    refresh();
  }
}
