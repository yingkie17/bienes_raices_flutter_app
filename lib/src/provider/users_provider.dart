/*
// =======  Configuracion para render.com ======= //

import 'dart:convert';
import 'dart:io';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

// Consulta http
class UsersProvider {
  static final String baseUrl = Entorno.baseUrl;
  static final String apiPath = Entorno.apiPath;
  // Método genérico para construir la URL base
  static Uri buildUrl(String path) {
    return Uri.https(baseUrl, '$apiPath/$path');
  }

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, {User sessionUser}) {
    this.context = context;
    this.sessionUser = sessionUser;
  }
//Método para obtener datos del usuario para cargar datos al drawer

  Future<User> getById(String id) async {
    try {
      Uri uri = buildUrl('users/findById/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La sesión expiró');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      User user = User.fromJson(data);
      return user;
    } catch (error) {
      print(
          'Error en el users_provider en el método Obtener Datos de Usuario getById, el error que se generó es: $error');
      return null;
    }
  }

//Método para obtener lista de agentes

//Método para obtener datos del usuario para cargar datos al drawer

  Future<List<User>> getAgentes() async {
    try {
      Uri uri = buildUrl('users/findAgent');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La sesión expiró');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      User user = User.fromJsonList(data);
      return user.toList;
    } catch (error) {
      print(
          'Error en el users_provider en el método Obtener Datos de Usuario getById, el error que se generó es: $error');
      return null;
    }
  }

//Metodo Registro con Imagen
  Future<Stream> createWithImage(User user, File image) async {
    try {
      Uri uri = buildUrl('users/create');
      final request = http.MultipartRequest('POST', uri);
      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // Enviar peticion

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print('Error en el método creareWithImageg en UserProvider... $error');
      return null;
    }
  }

  //Metodo Registro agente con Iamgen
  Future<Stream> createAgent(User user, File image) async {
    try {
      Uri uri = buildUrl('/api/users/create/agent');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = sessionUser.sessionToken;
      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // Enviar peticion

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print('Error en el método creareWithImageg en UserProvider... $error');
      return null;
    }
  }

//Método para editar perfil

  Future<Stream> update(User user, File image) async {
    try {
      Uri uri = buildUrl('users/update');
      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = sessionUser.sessionToken;
      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // Enviar peticion

      if (response.statusCode == 401) {
        MySnackbar.show(context, 'La sesión expiró');
        new SharedPref().logout(context, sessionUser.id);
      }

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print(
          'Error en el método editar perfil de usuario... el error que se generó es: $error');
      return null;
    }
  }

//metodo crear usuario
  Future<ResponseApi> create(User user) async {
    try {
      Uri uri = buildUrl('users/create');
      String bodyParams = json.encode(user);
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en el metodo create el siguiente error: $error');
      return null;
    }
  }

  Future<ResponseApi> login(String email, String password) async {
    try {
      // Usar el método buildUrl para construir la URL completa
      Uri uri = buildUrl('users/login');
      String bodyParams = json.encode({
        'email': email,
        'password': password,
      });
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print('Error en user_provider en el método login: $error');
      return null;
    }
  }

//metodo a Api logout
  Future<ResponseApi> logout(String idUser) async {
    try {
      Uri uri = buildUrl('users/logout');
      String bodyParams = json.encode({
        'id': idUser,
      });
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en el metodo create el siguiente error: $error');
      return null;
    }
  }
}


// ======= End of Configuracion para render.com ======= //
  
*/

// ======= Configuracion para Red Local Nodejs ======= //

import 'dart:convert';
import 'dart:io';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

// Consulta http
class UsersProvider {
  String _url = Entorno.API_BIENESRAICES;
  String _api = '/api/users';

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, {User sessionUser}) {
    this.context = context;
    this.sessionUser = sessionUser;
  }
//Método para obtener datos del usuario para cargar datos al drawer

  Future<User> getById(String id) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findById/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La sesión expiró');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      User user = User.fromJson(data);
      return user;
    } catch (error) {
      print(
          'Error en el users_provider en el método Obtener Datos de Usuario getById, el error que se generó es: $error');
      return null;
    }
  }

//Método para obtener lista de agentes

//Método para obtener datos del usuario para cargar datos al drawer

  Future<List<User>> getAgentes() async {
    try {
      Uri uri = Uri.http(_url, '$_api/findAgent');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La sesión expiró');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      User user = User.fromJsonList(data);
      return user.toList;
    } catch (error) {
      print(
          'Error en el users_provider en el método Obtener Datos de Usuario getById, el error que se generó es: $error');
      return null;
    }
  }

//Metodo Registro con Imagen
  Future<Stream> createWithImage(User user, File image) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', uri);
      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // Enviar peticion

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print('Error en el método creareWithImageg en UserProvider... $error');
      return null;
    }
  }

//Método para editar perfil

  Future<Stream> update(User user, File image) async {
    try {
      Uri uri = Uri.http(_url, '$_api/update');
      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = sessionUser.sessionToken;
      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // Enviar peticion

      if (response.statusCode == 401) {
        MySnackbar.show(context, 'La sesión expiró');
        new SharedPref().logout(context, sessionUser.id);
      }

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print(
          'Error en el método editar perfil de usuario... el error que se generó es: $error');
      return null;
    }
  }

//metodo crear usuario
  Future<ResponseApi> create(User user) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(user);
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en el metodo create el siguiente error: $error');
      return null;
    }
  }

//Consulta a Api login
  Future<ResponseApi> login(String email, String password) async {
    try {
      Uri uri = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({
        'email': email,
        'password': password,
      });
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en el metodo login el siguiente error: $error');
      return null;
    }
  }

//metodo a Api logout
  Future<ResponseApi> logout(String idUser) async {
    try {
      Uri uri = Uri.http(_url, '$_api/logout');
      String bodyParams = json.encode({
        'id': idUser,
      });
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = new ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print(
          'error: Se obtuvo un error en user_provider en el metodo create el siguiente error: $error');
      return null;
    }
  }

//Metodo Registro con Imagen
  Future<Stream> createAgent(User user, File image) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = sessionUser.sessionToken;
      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // Enviar peticion

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print('Error en el método creareWithImageg en UserProvider... $error');
      return null;
    }
  }
}



// ======= End of Configuracion para Red Local Nodejs ======= //
