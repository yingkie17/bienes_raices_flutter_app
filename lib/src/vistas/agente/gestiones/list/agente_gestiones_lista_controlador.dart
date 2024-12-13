import 'package:bienes_raices_app/src/modelos/order_model.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/orders_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:bienes_raices_app/src/vistas/agente/gestiones/detalle/agente_gestiones_detalle_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AgenteGestionesListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  User user;
  bool isUpdated;
  List<String> status = ['Curso', 'Negociacion', 'Concretado', 'Cancelado'];
  OrdersProvider _ordersProvider = new OrdersProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    User sessionUser = User.fromJson(await _sharedPref.read('user'));
    if (sessionUser != null) {
      // Si el usuario no es null, inicializa el proveedor de órdenes con el usuario
      _ordersProvider.init(context, sessionUser);
    } else {
      // Manejar el caso en el que no se pueda obtener el usuario de la sesión
      print('No se pudo obtener el usuario de la sesión');
      // Aquí podrías mostrar un mensaje de error o realizar alguna otra acción
    }
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    return await _ordersProvider.getByAgentAndStatus(user?.id, status);
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
    Navigator.pushNamed(context, 'inmobiliaria/propiedades/list');
  }

  void openBottomSheet(Order order) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => AgenteGestionesDetallePage(order: order));

    if (isUpdated == true) {
      refresh();
    }
  }
}
