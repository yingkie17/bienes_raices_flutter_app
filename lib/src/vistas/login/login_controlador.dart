import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/users_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginControlador {
  BuildContext context;

  TextEditingController correoController = new TextEditingController();
  TextEditingController contrasenaController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context) async {
    this.context = context;
    await usersProvider.init(context);
    //validamos si el usuario esta logueado
    User user = User.fromJson(await _sharedPref.read('user') ?? {});
    //Mostrar que usuario esta logueado
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Usuario deslogueado'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red[600],
    ));

    //Se valida si no exite una sesion iniciada se valida si session Token contiene algun dato y si es diferente de null
    if (user?.sessionToken != null) {
      if (user.roles.length > 1) {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
      }
    }
  }

// Boton que redirecciona a pantalla de Registro
  void goToRegistroPage() {
    Navigator.pushNamed(context, 'registro');
  }

  void login() async {
    //Vamos a Capturar el texto del textfiel
    String email = correoController.text.trim();
    String password = contrasenaController.text.trim();
    ResponseApi responseApi = await usersProvider.login(email, password);

    // print('Respueta de Login: ${responseApi.toJson()}');

    if (responseApi.success) {
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());
      print('Un usuario logueado actualmente: ${user.toJson()}');
      //Cuando el Usuario este logueado se va validar que roles asignadostiene el usuario
      if (user.roles.length > 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Usuario logueado'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: ColorsTheme.primaryColor,
        ));
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Usuario logueado'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: ColorsTheme.primaryColor,
        ));
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${responseApi.message}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
    }
  }
}
