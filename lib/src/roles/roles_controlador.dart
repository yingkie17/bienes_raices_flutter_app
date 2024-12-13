import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class RolesControlador {
  BuildContext context;
  Function refresh;
  User user;
  SharedPref sharedPreferences = new SharedPref();
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    //Obtener el usuario de sesión, usuario logueado
    user = User.fromJson(await sharedPreferences.read('user'));
    refresh();
  }

  // Evento click para menu de roles

  void goToPage(String ruta) {
    Navigator.pushNamedAndRemoveUntil(context, ruta, (route) => false);
  }

  //Método cerrar sesión
  logout() {
    _sharedPref.logout(context, user.id);
  }
}
