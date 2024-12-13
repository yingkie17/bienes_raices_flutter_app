import 'package:bienes_raices_app/id_reports/id_reports.dart';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/order_model.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/orders_provider.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/provider/users_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class InmobiliariaOrdenesDetalleController {
  BuildContext context;
  Function refresh;
  Product product;

  Order order;
  SharedPref _sharedPref = new SharedPref();
  User user;
  List<User> users = [];
  UsersProvider _usersProvider = new UsersProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  String idAgente;
  ReporteProvider _reporteProvider = new ReporteProvider();
  ReportsHasReports reportsHasReports;
  Idreports _idreports = new Idreports();
  String userId;
  String idUserAgente;
  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context, sessionUser: user);
    _ordersProvider.init(context, user);
    _progressDialog = new ProgressDialog(context: context);
    _reporteProvider.init(context, user);
    idUserAgente = user.id;
    await getAgentes();

    refresh();
  }

  void updateOrder() async {
    if (idAgente != null) {
      order.idAgent = idAgente;
      ResponseApi responseApi =
          await _ordersProvider.updateTicketToCurso(order);

      if (responseApi.success) {
        // Generar un reporte al cancelar la orden
        ReportsHasReports reportsHasReports = new ReportsHasReports(
          idReports:
              '${_idreports.idReportAsiganacionOdernAgente.toString()}', // ID del tipo de reporte para las órdenes canceladas
          idUser: '${user.id}',
          idAgent: null,
          nameReport:
              'Se Asignó un agente a la orden ${order.agent.name} ${order.agent.lastname},\n Id Orden: ${order.id},\n',
          descriptionReport:
              'Se Asignó un agente a la orden Id: ${order.id},\n Agente Asiganado: ${order.client.name}, ${order.client.lastname},\n\n=== Datos de Cliente ===\n \n Nombre: ${order.client.name},\n Apellidos: ${order.client.lastname},\n E-mail ${order.client.email},\n\n  === Datos de Orden === \n\n id: ${order.id},\n Fecha: ${order.timestamp},\n Lugar de la Cita:${order.address.address} \n\n',
        );
        ResponseApi reportResponse =
            await _reporteProvider.addReportClient(reportsHasReports);
        if (reportResponse.success) {
        } else {
          _progressDialog.close();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${reportResponse.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[600],
          ));
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${responseApi.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.lightGreen[900],
        ));

        Navigator.of(context).pop();
        _progressDialog.close();
        // Cerrar la pantalla actual después de 2 segundos
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
              context, 'inmobiliaria/ordenes/list', (route) => false);
        });
      } else {
        _progressDialog.close();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${responseApi.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
        return;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe Seleccionar un Agente'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }
  }

  void getAgentes() async {
    users = await _usersProvider.getAgentes();
    refresh();
  }
}
