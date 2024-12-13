/*
// ======= Configuracion para render.com ======= //

import 'dart:convert';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/categoria_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriaProvider {
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
  Future<List<Category>> getAll() async {
    try {
      Uri uri = buildUrl('categories/getAll');
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
      Category category = Category.fromJsonList(data);
      return category.toList;
    } catch (error) {
      print(
          'Se Produjo un error en categoria_provider en el método obtener lista de categorias de servios, Error: $error');
      return [];
    }
  }

  //Método crear usuario
  Future<ResponseApi> create(Category category) async {
    try {
      Uri uri = buildUrl('categories/create');
      String bodyParams = json.encode(category);
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
          'error: Se obtuvo un error en categoria_provider en el método create,  Error: $error');

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
import 'package:bienes_raices_app/src/modelos/categoria_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriaProvider {
  String _url = Entorno.API_BIENESRAICES;
  String _api = '/api/categories';

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  //Método para obtener la lista de todas las categorias de servicios
  Future<List<Category>> getAll() async {
    try {
      Uri uri = Uri.http(_url, '$_api/getAll');
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
      Category category = Category.fromJsonList(data);
      return category.toList;
    } catch (error) {
      print(
          'Se Produjo un error en el método obtener lista de categorias de servios, Error: $error');
      return [];
    }
  }

  //Método crear usuario
  Future<ResponseApi> create(Category category) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(category);
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
          'error: Se obtuvo un error en user_provider en el método create,  Error: $error');

      return null;
    }
  }
}


// ======= End of Configuracion para Red Local Nodejs ======= //


