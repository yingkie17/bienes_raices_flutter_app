import 'package:bienes_raices_app/src/modelos/order_model.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/orders_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:bienes_raices_app/src/vistas/cliente/ordenes/detalle/cliente_ordenes_detalle_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClienteOrdenesListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  User user;
  bool isUpdated;
  List<String> status = [
    'Espera',
    'Curso',
    'Negociacion',
    'Concretado',
    'Cancelado'
  ];
  OrdersProvider _ordersProvider = new OrdersProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _ordersProvider.init(context, user);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    //pasamos el id de sesion de usuario que es el cliente
    return await _ordersProvider.getByClientAndStatus(user?.id, status);
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

  void openBottomSheet(Order order) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClienteOrdenesDetallePage(order: order));

    if (isUpdated == true) {
      refresh();
    }
  }
}
