import 'dart:async';

import 'package:bienes_raices_app/src/modelos/categoria_model.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/categoria_provider.dart';
import 'package:bienes_raices_app/src/provider/producto_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:bienes_raices_app/src/vistas/cliente/propiedades/detalle/cliente_propiedades_detalle_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientePropiedadesListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  User user;
  List<Category> categories = [];
  CategoriaProvider _categoriaProvider = new CategoriaProvider();
  ProductoProvider _productoProvider = new ProductoProvider();
  Timer searchStoppedTyping;
  String nombrePropiedad = '';

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _categoriaProvider.init(context, user);
    _productoProvider.init(context, user);
    getCategories();
    refresh();
  }

  Future<List<Product>> getProducts(
      String id_category, String productName) async {
    if (nombrePropiedad.isEmpty) {
      return await _productoProvider.getByCategory(id_category);
    } else {
      return await _productoProvider.getByCategoryAndProductName(
          id_category, productName);
    }
  }

  void onChangedText(String text) {
    Duration duration = new Duration(milliseconds: 800);
    if (searchStoppedTyping != null) {
      searchStoppedTyping.cancel();
      refresh();
    }
    searchStoppedTyping = new Timer(duration, () {
      nombrePropiedad = text;
      refresh();

      print('Texto Completo: $nombrePropiedad');
    });
  }

  void getCategories() async {
    categories = await _categoriaProvider.getAll();
    refresh();
  }

  void openBottomSheet(Product product) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientePropiedadesDetallePage(
              product: product,
            ));
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
