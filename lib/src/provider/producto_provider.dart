/*
// ======= Configuracion para render.com ======= //

import 'dart:convert';
import 'dart:io';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductoProvider {
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

//Metodo Registro nuevo producto o propiedad con images
  Future<Stream> create(Product product, List<File> images) async {
    try {
      Uri uri = buildUrl('products/create');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = sessionUser.sessionToken;

      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path)));
      }

      /////////////////////////////
      request.fields['product'] = json.encode(product);
      final response = await request.send(); // Enviar peticion

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print(
          'Error en prodcto_provider en el método create ProductProvider... $error');
      return null;
    }
  }

  Future<Stream> updateProduct(
      Product product, String id, List<File> images) async {
    // Product product, String id) async {

    try {
      // Construye la URL de la solicitud
      Uri uri = buildUrl('products/updateProduct/$id');
      // Inicializa una nueva solicitud de tipo MultipartRequest
      final request = http.MultipartRequest('PUT', uri);

      request.headers['Authorization'] = sessionUser.sessionToken;

      // Adjunta las imágenes a la solicitud

      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path)));
      }

      // Adjunta los datos del producto directamente en el cuerpo de la solicitud

      // Sin Hardcodear
      request.fields['product'] = json.encode(product);

      //Hardcodeando por el error que se esta obteniendo
/*
      request.fields['id'] = product.id.toString();
      request.fields['quantity'] = product.quantity.toString();
      request.fields['name_product'] = product.nameProduct;
      request.fields['price_product'] = product.priceProduct.toString();
      request.fields['commission_product'] =
          product.commissionProduct.toString();
      request.fields['city_product'] = product.cityProduct;
      request.fields['address_product'] = product.addressProduct;
      request.fields['phone_product'] = product.phoneProduct;
      request.fields['description_product'] = product.descriptionProduct;
      request.fields['area_product'] = product.areaProduct;
      request.fields['name_owner'] = product.nameOwner;
      request.fields['lastname_owner'] = product.lastnameOwner;
      request.fields['phone_owner'] = product.phoneOwner;
      request.fields['email_owner'] = product.emailOwner;
      request.fields['ci_owner'] = product.ciOwner;
      request.fields['id_contract'] = product.idContract;
      request.fields['image1'] = product.imageProduct1;
      request.fields['image2'] = product.imageProduct2;
      request.fields['image3'] = product.imageProduct3;
      request.fields['image4'] = product.imageProduct4;
      request.fields['image5'] = product.imageProduct5;
      request.fields['image6'] = product.imageProduct6;
      request.fields['id_category'] = product.idCategory;
*/
      // Envia la solicitud
      final response = await request.send();

      // Retorna el flujo de respuesta
      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print(
          'Error en el método actualizar información de producto en ProductProvider... $error');
      return null;
    }
  }

//Método para obtener la lista de productos según su categoria
  //Método para obtener la lista de todas las categorias de servicios
  Future<List<Product>> getByCategory(String id_category) async {
    try {
      Uri uri = buildUrl('products/findByCategory/$id_category');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
        return [];
      }

      //======================

      final data = json.decode(res.body);
      if (data['success'] == true && data['data'] is List) {
        List<Product> productList = (data['data'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
        return productList;
      }

      //=====================

      else {
        print('Respuesta inválida del servidor: $data');
        return [];
      }
    } catch (error) {
      print(
          'Se Produjo un error en prodcto_provider en el método obtener lista de categorias de servios, Error: $error');
      return [];
    }
  }

//Método para Buscador

//Método para obtener la lista de todas las categorias de servicios
  Future<List<Product>> getByCategoryAndProductName(
      String id_category, String productName) async {
    try {
      Uri uri = buildUrl(
          'products/findByCategoryAndProductName/$id_category/$productName');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
        return [];
      }

      //======================

      final data = json.decode(res.body);
      if (data['success'] == true && data['data'] is List) {
        List<Product> productList = (data['data'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
        return productList;
      }

      //=====================

      else {
        print('Respuesta inválida del servidor: $data');
        return [];
      }
    } catch (error) {
      print(
          'Se Produjo un error en prodcto_provider en el método obtener lista de categorias de servios, Error: $error');
      return [];
    }
  }
}

// ======= End of Configuracion para render.com ======= //


*/

// =======Configuracion para Red Local Nodejs ======= //

import 'dart:convert';
import 'dart:io';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductoProvider {
  String _url = Entorno.API_BIENESRAICES;
  String _api = '/api/products';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

//Metodo Registro nuevo producto o propiedad con 3 Imagenes
  Future<Stream> create(Product product, List<File> images) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = sessionUser.sessionToken;

      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path)));
      }

      /////////////////////////////
      request.fields['product'] = json.encode(product);
      final response = await request.send(); // Enviar peticion
      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print('Error en el método create en ProductProvider... $error');
      return null;
    }
  }

  Future<Stream> updateProduct(
      Product product, String id, List<File> images) async {
    // Product product, String id) async {

    try {
      // Construye la URL de la solicitud
      Uri uri = Uri.http(_url, '$_api/updateProduct/$id');

      // Inicializa una nueva solicitud de tipo MultipartRequest
      final request = http.MultipartRequest('PUT', uri);

      request.headers['Authorization'] = sessionUser.sessionToken;

      // Adjunta las imágenes a la solicitud

      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path)));
      }

      // Adjunta los datos del producto directamente en el cuerpo de la solicitud

      // Sin Hardcodear
      request.fields['product'] = json.encode(product);

      //Hardcodeando por el error que se esta obteniendo
/*
      request.fields['id'] = product.id.toString();
      request.fields['quantity'] = product.quantity.toString();
      request.fields['name_product'] = product.nameProduct;
      request.fields['price_product'] = product.priceProduct.toString();
      request.fields['commission_product'] =
          product.commissionProduct.toString();
      request.fields['city_product'] = product.cityProduct;
      request.fields['address_product'] = product.addressProduct;
      request.fields['phone_product'] = product.phoneProduct;
      request.fields['description_product'] = product.descriptionProduct;
      request.fields['area_product'] = product.areaProduct;
      request.fields['name_owner'] = product.nameOwner;
      request.fields['lastname_owner'] = product.lastnameOwner;
      request.fields['phone_owner'] = product.phoneOwner;
      request.fields['email_owner'] = product.emailOwner;
      request.fields['ci_owner'] = product.ciOwner;
      request.fields['id_contract'] = product.idContract;
      request.fields['image1'] = product.imageProduct1;
      request.fields['image2'] = product.imageProduct2;
      request.fields['image3'] = product.imageProduct3;
      request.fields['image4'] = product.imageProduct4;
      request.fields['image5'] = product.imageProduct5;
      request.fields['image6'] = product.imageProduct6;
      request.fields['id_category'] = product.idCategory;
*/
      // Envia la solicitud
      final response = await request.send();

      // Retorna el flujo de respuesta
      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print(
          'Error en el método actualizar información de producto en ProductProvider... $error');
      return null;
    }
  }

//Método para obtener la lista de productos según su categoria
  //Método para obtener la lista de todas las categorias de servicios
  Future<List<Product>> getByCategory(String id_category) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findByCategory/$id_category');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);

      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
        return [];
      }

      //======================

      final data = json.decode(res.body);
      if (data['success'] == true && data['data'] is List) {
        List<Product> productList = (data['data'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
        return productList;
      }

      //=====================

      else {
        print('Respuesta inválida del servidor: $data');
        return [];
      }
    } catch (error) {
      print(
          'Se Produjo un error en el método obtener lista de categorias de servios, Error: $error');
      return [];
    }
  }

//Método para Buscador

//Método para obtener la lista de todas las categorias de servicios
  Future<List<Product>> getByCategoryAndProductName(
      String id_category, String productName) async {
    try {
      Uri uri = Uri.http(
          _url, '$_api/findByCategoryAndProductName/$id_category/$productName');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'La Sesion ha expirado');
        new SharedPref().logout(context, sessionUser.id);
        return [];
      }

      //======================

      final data = json.decode(res.body);
      if (data['success'] == true && data['data'] is List) {
        List<Product> productList = (data['data'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
        return productList;
      }

      //=====================

      else {
        print('Respuesta inválida del servidor: $data');
        return [];
      }
    } catch (error) {
      print(
          'Se Produjo un error en el método obtener lista de categorias de servios, Error: $error');
      return [];
    }
  }
}

// ======= End of Configuracion para Red Local Nodejs ======= //

