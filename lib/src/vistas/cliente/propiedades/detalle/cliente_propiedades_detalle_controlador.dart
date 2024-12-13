import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientePropiedadesDetalleController {
  BuildContext context;
  Function refresh;
  Product product;
  int counter = 1;
  double productPrice;
  SharedPref _sharedPref = new SharedPref();

  List<Product> selectedProducts = [];

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product.priceProduct;

    //_sharedPref.remove('order');

    selectedProducts =
        Product.fromJsonList(await _sharedPref.read('order')).toList;
    selectedProducts.forEach((p) {
      print('Productos Agreagos a la Bolsa: ${p.toJson()}');
    });

    refresh();
  }

  void addToBag() {
    int index =
        selectedProducts.indexWhere((element) => element.id == product.id);
    if (index == -1) {
      if (product.quantity == null) {
        product.quantity = 1;
      }
      selectedProducts.add(product);
    } else {
      selectedProducts[index].quantity = counter;
    }
    // Agregar la propiedad a la bolsa
    _sharedPref.save('order', selectedProducts);

    // Imprimir los productos seleccionados en la consola
    print('Productos Seleccionados:');
    selectedProducts.forEach((p) {
      print(p.toJson());
    });

    // Mostrar un Dialog con el mensaje
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'La Propiedad fue Agregada',
            style: TextStyle(
              fontFamily: 'NinbusSans',
            ),
          ),
          content: Text(
              'La propiedad ha sido agregada a la bolsa de propiedades, para continuar con el proceso de colsulta deberá generar una cita con un agente inmobiliario y configurar la direccion y fecha y la hora. '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'cliente/ordenes/crear');
              },
              child: Text(
                'Continuar con la consulta',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cerrar',
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void addItem() {
    counter = counter + 1;
    productPrice = product.priceProduct * counter;
    product.quantity = counter;
    refresh();
  }

  void removeItem() {
    if (counter > 1) {
      counter = counter - 1;
      productPrice = product.priceProduct * counter;
      product.quantity = counter;
      refresh();
    }
  }

  void llamarCliente() {
    final uri = Uri.parse("tel://${product.phoneProduct}");
    launchUrl(uri);
  }

  void close() {
    Navigator.pop(context);
  }
}
