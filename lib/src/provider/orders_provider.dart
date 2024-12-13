/*
// ======= Configuracion para render.com ======= //

import 'dart:convert';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/order_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersProvider {
  static final String baseUrl = Entorno.baseUrl;
  static final String apiPath = Entorno.apiPath;
  // Método genérico para construir la URL base
  static Uri buildUrl(String path) {
    return Uri.https(baseUrl, '$apiPath/$path');
  }

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  //Método para obtener la lista de todas las categorias de servicios
  Future<List<Order>> getByStatus(String status) async {
    try {
      Uri uri = buildUrl('orders/findByStatus/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      Order order = Order.fromJsonList(data);
      return order.toList;
    } catch (error) {
      print(
          'Se Produjo un error en orders_provider en el método obtener lista de ordenes según su estatus, Error: $error');
      return [];
    }
  }

//Método para obtener la lista de órdenes que pertenecen al agente
  Future<List<Order>> getByAgentAndStatus(String idAgent, String status) async {
    try {
      Uri uri = buildUrl('orders/findByAgentAndStatus/$idAgent/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      Order order = Order.fromJsonList(data);
      return order.toList;
    } catch (error) {
      print(
          'Se Produjo un error en orders_provider en el método obtener lista de ordenes según su estatus, Error: $error');
      return [];
    }
  }

  //Método para obtener la lista de órdenes que pertenecen al cliente
  Future<List<Order>> getByClientAndStatus(
      String idClient, String status) async {
    try {
      Uri uri = buildUrl('orders/findByClientAndStatus/$idClient/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      Order order = Order.fromJsonList(data);
      return order.toList;
    } catch (error) {
      print(
          'Se Produjo un error en orders_provider en el método obtener lista de ordenes según su estatus, Error: $error');
      return [];
    }
  }

  //Método crear orden
  Future<ResponseApi> create(Order order) async {
    try {
      Uri uri = buildUrl('orders/create');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.post(uri, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en orders_provider en el método create,  Error: $error');

      return null;
    }
  }

  //Método actualizar estatus del ticket a estatus Curso
  Future<ResponseApi> updateTicketToCurso(Order order) async {
    try {
      Uri uri = buildUrl('orders/updateTicketToCurso');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en orders_provider en actualizar estatus Curso (updateTicketToCurso),  Error: $error');

      return null;
    }
  }

//Método actualizar estatus del ticket a estatus Negociación
  Future<ResponseApi> updateTicketToNegociacion(Order order) async {
    try {
      Uri uri = buildUrl('orders/updateTicketToNegociacion');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en orders_provider en actualizar estatus (updateTicketToConcretado) ,  Error: $error');

      return null;
    }
  }

  //Método actualizar estatus del ticket a estatus Concretado
  Future<ResponseApi> updateTicketToConcretado(Order order) async {
    try {
      Uri uri = buildUrl('orders/updateTicketToConcretado');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en ordes_provider en actualizar estatus (updateTicketToConcretado) ,  Error: $error');

      return null;
    }
  }

  //Método actualizar estatus del ticket a estatus Cancelado
  Future<ResponseApi> updateTicketToCancelado(Order order) async {
    try {
      Uri uri = buildUrl('orders/updateTicketToCancelado');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en actualizar el estatus de Cancelado (updateTicketToCancelado),  Error: $error');

      return null;
    }
  }

  //Método actualizar estatus del mapa
  Future<ResponseApi> updateLatLng(Order order) async {
    try {
      Uri uri = buildUrl('orders/updateLatLng');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en actualizar estatus (updateTicketToConcretado) ,  Error: $error');

      return null;
    }
  }
}


// ======= End of Configuracion para render.com ======= //

*/

// ======= Configuracion para Red Local Nodejs ======= //

import 'dart:convert';

import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/order_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersProvider {
  String _url = Entorno.API_BIENESRAICES;
  String _api = '/api/orders';

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  //Método para obtener la lista de todas las categorias de servicios
  Future<List<Order>> getByStatus(String status) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findByStatus/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      Order order = Order.fromJsonList(data);
      return order.toList;
    } catch (error) {
      print(
          'Se Produjo un error en el método obtener lista de ordenes según su estatus, Error: $error');
      return [];
    }
  }

//Método para obtener la lista de órdenes que pertenecen al agente
  Future<List<Order>> getByAgentAndStatus(String idAgent, String status) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findByAgentAndStatus/$idAgent/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      Order order = Order.fromJsonList(data);
      return order.toList;
    } catch (error) {
      print(
          'Se Produjo un error en el método obtener lista de ordenes según su estatus, Error: $error');
      return [];
    }
  }

  //Método para obtener la lista de órdenes que pertenecen al cliente
  Future<List<Order>> getByClientAndStatus(
      String idClient, String status) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findByClientAndStatus/$idClient/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      Order order = Order.fromJsonList(data);
      return order.toList;
    } catch (error) {
      print(
          'Se Produjo un error en el método obtener lista de ordenes según su estatus, Error: $error');
      return [];
    }
  }

  //Método crear orden
  Future<ResponseApi> create(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.post(uri, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en orders_provider en el método create,  Error: $error');

      return null;
    }
  }

  //Método actualizar estatus del ticket a estatus Curso
  Future<ResponseApi> updateTicketToCurso(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/updateTicketToCurso');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en actualizar estatus Curso (updateTicketToCurso),  Error: $error');

      return null;
    }
  }

//Método actualizar estatus del ticket a estatus Negociación
  Future<ResponseApi> updateTicketToNegociacion(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/updateTicketToNegociacion');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en actualizar estatus (updateTicketToConcretado) ,  Error: $error');

      return null;
    }
  }

  //Método actualizar estatus del ticket a estatus Concretado
  Future<ResponseApi> updateTicketToConcretado(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/updateTicketToConcretado');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en actualizar estatus (updateTicketToConcretado) ,  Error: $error');

      return null;
    }
  }

  //Método actualizar estatus del ticket a estatus Cancelado
  Future<ResponseApi> updateTicketToCancelado(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/updateTicketToCancelado');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en actualizar el estatus de Cancelado (updateTicketToCancelado),  Error: $error');

      return null;
    }
  }

  //Método actualizar estatus del mapa
  Future<ResponseApi> updateLatLng(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/updateLatLng');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en actualizar estatus (updateTicketToConcretado) ,  Error: $error');

      return null;
    }
  }
}




// ======= End of Configuracion para Red Local Nodejs ======= //