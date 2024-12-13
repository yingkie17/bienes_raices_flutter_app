import 'dart:io';
import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/imports/imports.dart';
import 'package:bienes_raices_app/src/modelos/estadisticas_model.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/estadisticas/inmobiliaria_estadiscas_controlador.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pie_chart/pie_chart.dart';

class InmobiliariaEstadicasPage extends StatefulWidget {
  const InmobiliariaEstadicasPage({Key key}) : super(key: key);

  @override
  State<InmobiliariaEstadicasPage> createState() =>
      _InmobiliariaEstadicasPageState();
}

class _InmobiliariaEstadicasPageState extends State<InmobiliariaEstadicasPage> {
  InmobiliariaEstadiscasController _controlador =
      new InmobiliariaEstadiscasController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      _controlador.init(context, refresh);
    });
  }

  List<Estadisticas> estadisticas = [
    new Estadisticas(id: '1', name: 'Metallica', votes: 5),
    new Estadisticas(id: '2', name: 'Breaking Benjamin', votes: 5),
    new Estadisticas(id: '3', name: 'Héroes del Silencio', votes: 5),
    new Estadisticas(id: '4', name: 'Bon jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 3,
          centerTitle: true,
          title: Text(
            'Métricas y Estadisticas',
            style: TextStyle(color: ColorsTheme.primaryColor),
          ),
        ),
        body: Column(
          children: [
            _mostrarGrafico(),
            Expanded(
              child: ListView.builder(
                itemCount: estadisticas.length,
                itemBuilder: (BuildContext context, int index) {
                  return estadisticasTile(estadisticas[index]);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 1,
          onPressed: addNewStat,
        ),
      ),
    );
  }

  Widget estadisticasTile(Estadisticas estadisticas) {
    return Dismissible(
      key: Key(estadisticas.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('Dirección $direction');
        print('Dirección ${estadisticas.id}');
        // Todo llamar el borrado del server
      },
      background: Container(
        padding: EdgeInsets.only(left: 30),
        color: Colors.red[600],
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Eliminar Métrica',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(estadisticas.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(estadisticas.name),
        trailing: Text(
          '${estadisticas.votes}',
          style: TextStyle(fontSize: 18, color: ColorsTheme.secondaryColor),
        ),
        onTap: () {
          print(estadisticas.name);
        },
      ),
    );
  }

  //Método para agregar un nuevo tipo de estadisticas
  addNewStat() {
    final TextEditingController estadisticaController =
        new TextEditingController();
// Para Android Importante para validar el tipo de plataforma se debe importar el el paquete dart:io
    if (Platform.isIOS) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Agregar nueva metrica'),
            content: TextField(
              controller: estadisticaController,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () =>
                    agregarMetricasToList(estadisticaController.text),
                child: Text('Agregar'),
                textColor: ColorsTheme.secondaryColor,
                elevation: 4,
              )
            ],
          );
        },
      );
    }
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Nueva Metrica'),
            content: CupertinoTextField(
              controller: estadisticaController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Agregar'),
                onPressed: () =>
                    agregarMetricasToList(estadisticaController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Cerrar'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void agregarMetricasToList(String name) {
    print(name);
    if (name.length > 1) {
      //Se puede agregar
      this.estadisticas.add(new Estadisticas(
          id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }

  //Mostrar Gráfica
  Widget _mostrarGrafico() {
    Map<String, double> dataMap = new Map();
    dataMap.putIfAbsent('Concretado', () => 1);
    dataMap.putIfAbsent('Cancelado', () => 10);
    dataMap.putIfAbsent('Atendidas', () => 6);
    dataMap.putIfAbsent('Desatendidas', () => 10);

    return PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
    );
  }

  void refresh() {
    setState(() {});
  }
}
