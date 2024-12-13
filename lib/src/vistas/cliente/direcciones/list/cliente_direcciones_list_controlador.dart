import 'package:bienes_raices_app/id_reports/id_reports.dart';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/direccion_modelo.dart';
import 'package:bienes_raices_app/src/modelos/order_model.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/address_provider.dart';
import 'package:bienes_raices_app/src/provider/orders_provider.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ClienteDireccionesListController {
  BuildContext context;
  Function refresh;
  List<Address> address = [];
  AddressProvider _addressProvider = new AddressProvider();
  User user;
  ReporteProvider _reporteProvider = new ReporteProvider();
  ReportsHasReports reportsHasReports;
  String idUserAgente;
  SharedPref _sharedPref = new SharedPref();
  int radioValue = 0;
  bool isCreated;
  ProgressDialog _progressDialog;
  Map<String, dynamic> dataIsCreated;
  OrdersProvider _ordersProvider = new OrdersProvider();
  Idreports _idreports = new Idreports();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);
    _reporteProvider.init(context, user);
    _progressDialog = ProgressDialog(context: context);
    idUserAgente = user.id;

    refresh();
  }

//Metodo del Botón

  void createOrder() async {
    Address modalAddress = await _sharedPref.read('address') != null
        ? Address.fromJson(await _sharedPref.read('address'))
        : null;

    if (modalAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No hay dirección seleccionada para crear la orden'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ));
      return; // Salir del método para evitar la creación de la orden con dirección nula
    }
    if (address.isEmpty) {
      // Manejar el caso de lista de direcciones vacía
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No hay direcciones disponibles para crear la orden'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ));
      return;
    }
    List<Product> selectedProducts =
        Product.fromJsonList(await _sharedPref.read('order')).toList;

    Order order = new Order(
        idClient: user.id,
        idAddress: modalAddress.id,
        products: selectedProducts);
    ResponseApi responseApi = await _ordersProvider.create(order);
    if (responseApi.success == true) {
      ReportsHasReports reportsHasReports = ReportsHasReports(
        idReports:
            '${_idreports.idReportCrearOrden.toString()}', // ID del tipo de reporte para actualización de producto
        idUser: '${user.id}',
        idProduct: null,
        nameReport:
            'Cración de nueva orden (Cliente): ${user.name}, ${user.lastname}',
        descriptionReport:
            'Se realizó la creación de orden,\n\n ===Datos de Nuevo Cliente===\n\n  Nombre: ${user.name},\n Apellidos: ${user.lastname},\n E-mail: ${user.email},\n Teléfono: ${user.phone} ',
      );
      ResponseApi reportResponse =
          await _reporteProvider.addReportRegisterClient(reportsHasReports);
      if (reportResponse.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${reportResponse.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.lightGreen[900],
        ));
      } else {
        _progressDialog.close();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${reportResponse.error}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
      }
      _progressDialog.close();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${responseApi.message}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen[900],
      ));
      Navigator.pushNamedAndRemoveUntil(
          context, 'cliente/ordenes/list', (route) => false);
    } else {
      _progressDialog.close();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${responseApi.message}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Por favor intenta crear una nueva dirección de cita con la ubicación'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orange[900],
      ));

      return;
    }
  }

//Método para manejar los controles de la lisa de direcciones
  void handleRadioValueChange(int value) async {
    radioValue = value;
    _sharedPref.save('address', address[value]);
    Address modalAddress =
        Address.fromJson(await _sharedPref.read('address') ?? {});

    print(
        'Se guardo la direccion que el usuario ha seleccionado ${modalAddress.toJson()}');
    refresh();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Valor Seleccionado: $radioValue'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.orange[800],
    ));
  }

  Future<List<Address>> getAddress() async {
    if (user != null) {
      address = await _addressProvider.getByUser(user.id);
      print(
          'Direcciones obtenidas'); // Agrega esta línea para actualizar el estado
      return address;
    } else {
      print('No se pudo obtener la lista de direcciones del usuario');
      return [];
    }
  }

  void goToCrearDireccion() {
    Navigator.pushNamed(context, 'cliente/direcciones/crear');
  }

  void goToNewDireccion() async {
    var result =
        await Navigator.pushNamed(context, 'cliente/direcciones/crear');
    if (result != null) {
      if (result) {
        refresh();
      }
    }
  }
}
