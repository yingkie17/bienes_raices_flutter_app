import 'dart:convert';

import 'package:bienes_raices_app/src/provider/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  void save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

//Método para leer la información almnacenada

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == null) return null;
    return json.decode(prefs.getString(key));
  }

//Método para saber si existe algun dato en el sharedpreferences
  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

//Metodo para eliminar un dato de sharedpreferences
  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<bool> saveList(String key, List<dynamic> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = list.map((item) => json.encode(item)).toList();
    return await prefs.setStringList(key, encodedList);
  }

  Future<List<dynamic>> readList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList(key) ?? [];
    return encodedList.map((item) => json.decode(item)).toList();
  }

  void logout(BuildContext context, String idUser) async {
    UsersProvider usersProvider = new UsersProvider();
    usersProvider.init(context);
    await usersProvider.logout(idUser);

    await remove('user');
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }
}
