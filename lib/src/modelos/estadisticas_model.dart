import 'package:flutter/foundation.dart';

class Estadisticas {
  String id;
  String name;
  int votes;

  Estadisticas({
    this.id,
    this.name,
    this.votes,
  });

//Sockets con Mapas

  factory Estadisticas.fromMap(Map<String, dynamic> obj) => Estadisticas(
        id: obj['id'],
        name: obj['name'],
        votes: obj['votes'],
      );
}
