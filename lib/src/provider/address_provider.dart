/*
// ======= Configuracion para render.com ======= //

import 'dart:convert';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/direccion_modelo.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressProvider {
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

  //Método para obtener la lista de todas las direcciónes
  Future<List<Address>> getByUser(String idUser) async {
    try {
      Uri uri = buildUrl('address/findByUser/${idUser}');

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
      Address address = Address.fromJsonList(data);
      return address.toList;
    } catch (error) {
      print(
          'Se Produjo un error en address_provider en el método obtener lista de categorias de servios, Error: $error');
      return [];
    }
  }

  //Método crear dirección
  Future<ResponseApi> create(Address address) async {
    try {
      Uri uri = buildUrl('address/create');
      String bodyParams = json.encode(address);
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
          'error: Se obtuvo un error en address_provider en el método create,  Error: $error');

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
import 'package:bienes_raices_app/src/modelos/direccion_modelo.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressProvider {
  String _url = Entorno.API_BIENESRAICES;
  String _api = '/api/address';

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  //Método para obtener la lista de todas las direcciónes
  Future<List<Address>> getByUser(String idUser) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findByUser/${idUser}');
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
      Address address = Address.fromJsonList(data);
      return address.toList;
    } catch (error) {
      print(
          'Se Produjo un error en el método obtener lista de direcciones para la órden en el address_provider, Error: $error');
      return [];
    }
  }

  //Método crear dirección
  Future<ResponseApi> create(Address address) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(address);
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
          'error: Se obtuvo un error en address_provider en el método create,  Error: $error');

      return null;
    }
  }
}

// ======= End of Configuracion para Red Local Nodejs ======= //


