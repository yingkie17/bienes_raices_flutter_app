import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ClienteOrdenesCrearController {
  BuildContext context;
  Function refresh;
  Product product;

  SharedPref _sharedPref = new SharedPref();

  List<Product> selectedProducts = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    selectedProducts =
        Product.fromJsonList(await _sharedPref.read('order')).toList;
    refresh();
  }

  void eliminarElemento(Product product) {
    selectedProducts.removeWhere((p) => p.id == product.id);
    _sharedPref.save('order', selectedProducts);
    // Mostrar un Dialog con el mensaje

    refresh();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Propiedad elimanda'),
          content: Text(
              'La propiedad ha sido eliminado de la lista de consulta de propiedades.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cerrar el Dialog
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

// Agregar Direcciones

  void goToDirecciones() {
    Navigator.pushNamed(context, 'cliente/direcciones/list');
  }
}
