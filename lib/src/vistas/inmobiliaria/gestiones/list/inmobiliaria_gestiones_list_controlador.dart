import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:flutter/material.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';

class InmobiliariaGestionesListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  User user;
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
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

  void goToModificarUsuario() {
    Navigator.pushNamed(context, 'cliente/modificar/usuario');
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToCrearCategorias() {
    Navigator.pushNamed(context, 'inmobiliaria/categoria/crear');
  }

  void goToCrearProductos() {
    Navigator.pushNamed(context, 'inmobiliaria/producto/crear');
  }

  void goToEstadoOrdenes() {
    Navigator.pushNamed(context, 'inmobiliaria/ordenes/list');
  }

  void goToReportes() {
    Navigator.pushNamed(context, 'inmobiliaria/reporte/crear');
  }

  void goToListReportes() {
    Navigator.pushNamed(context, 'inmboliliaria/reporte/general/list');
  }

  void goToEditarPropiedad() {
    Navigator.pushNamed(context, 'inmobiliaria/producto/editar');
  }

  void goToCrearAgente() {
    Navigator.pushNamed(context, 'inmobiliaria/registrar/agente');
  }

  void goToEstadisticas() {
    Navigator.pushNamed(context, 'inmobiliaria/estadisticas');
  }

  void goToServerStatus() {
    Navigator.pushNamed(context, 'server/satus');
  }

  void goToReporteAgente() {
    Navigator.pushNamed(context, 'inmobiliaria/reporte/agente/list');
  }
}
