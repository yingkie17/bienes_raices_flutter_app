import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Conectado, Desconectado, Conectando }

class ServerStatusProvider with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Conectando;

  get serverStatus => this._serverStatus;

  ServerStatusProvider() {
    this._initConfig();
  }

  void _initConfig() {
    IO.Socket socket =
        IO.io('http://${Entorno.API_BIENESRAICES}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('Conectado al socket');
      this._serverStatus = ServerStatus.Conectado;
      notifyListeners();
    });
    socket.on('disconnect', (_) {
      print('Desconectado del socket');
      this._serverStatus = ServerStatus.Conectado;
      notifyListeners();
    });

    socket.on('nuevo-mensaje', (payload) {
      print('Nuevo mensaje: $payload');
      notifyListeners();
    });
  }
}
