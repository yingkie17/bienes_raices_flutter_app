import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/src/modelos/estadisticas_model.dart';
import 'package:bienes_raices_app/src/provider/sever_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServerStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final estadisticasProvider = Provider.of<ServerStatusProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.only(top: 60),
            child: Row(
              children: [
                Text(
                  'Estado de la conexion:',
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
                Text(
                  ' ${estadisticasProvider.serverStatus}',
                  style: TextStyle(
                      fontSize: 14, color: ColorsTheme.secondaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      ),
    );
  }
}
