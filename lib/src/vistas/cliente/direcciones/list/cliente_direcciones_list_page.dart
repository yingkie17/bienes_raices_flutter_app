import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/assets/widgets/no_data_widgets.dart';
import 'package:bienes_raices_app/src/modelos/direccion_modelo.dart';
import 'package:bienes_raices_app/src/vistas/cliente/direcciones/list/cliente_direcciones_list_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class CLienteDireccionesListPage extends StatefulWidget {
  const CLienteDireccionesListPage({Key key}) : super(key: key);

  @override
  State<CLienteDireccionesListPage> createState() =>
      _CLienteDireccionesListPageState();
}

class _CLienteDireccionesListPageState
    extends State<CLienteDireccionesListPage> {
  ClienteDireccionesListController _controlador =
      new ClienteDireccionesListController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isTimeEnabled = false;
  bool isDateEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controlador.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direcciones'),
        actions: [
          Container(
            width: 100,
            margin: EdgeInsets.only(top: 15),
            child: Text(
              'Agregar  nueva dirección',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),
          _iconAdd(),
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.16,
        child: Column(
          children: [_confirmarButton()],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: _seleccionarTextoDireccion(),
          ),
          Container(
            margin: EdgeInsets.only(top: 90),
            child: _listaDirecciones(),
          )
        ],
      ),
    );
  }

  Widget _sinDireccion() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          child: NoDataWidets(
            text: 'Ninguna dirección fúe agregada a la lista',
          ),
        ),
        _nuevaDireccionButton(),
      ],
    );
  }

  Widget _listaDirecciones() {
    return FutureBuilder(
        future: _controlador.getAddress(),
        builder: (context, AsyncSnapshot<List<Address>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (_, index) {
                  return _radioSelectorDireccion(snapshot.data[index], index);
                },
              );
            } else {
              return _sinDireccion();
            }
          } else {
            return _sinDireccion();
          }
        });
  }

  Widget _radioSelectorDireccion(Address address, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: _controlador.radioValue,
                onChanged: _controlador.handleRadioValueChange,
              ),
              Container(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address?.address ?? '',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NimbusSans'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      address?.neighborhood ?? '',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'NimbusSans'),
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('HH:mm').format(DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            address.timeEvent.hour,
                            address.timeEvent.minute,
                          )),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NimbusSans'),
                        ),
                        SizedBox(width: 20),
                        Text(
                          DateFormat('dd-MM-yyyy').format(address?.dateEvent) ??
                              '',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NimbusSans'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
          )
        ],
      ),
    );
  }

  Widget _iconAdd() {
    return IconButton(
        onPressed: _controlador.goToNewDireccion,
        icon: Icon(
          Icons.add_circle_outline,
          color: Colors.white,
          size: 35,
        ));
  }

//Texto Elegir dirección
  Widget _seleccionarTextoDireccion() {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 0),
      child: Text(
        'Elige una dirección para encontrarte con nuestros agentes',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'NimbusSans'),
      ),
    );
  }

  //Boton nueva Dirección
  Widget _nuevaDireccionButton() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 50,
      width: 250,
      child: ElevatedButton(
        onPressed: _controlador.goToCrearDireccion,
        child: Text('Agregar Nueva Direccíon y Fecha'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
        ),
      ),
    );
  }

// Botón de Aceptar

  Widget _confirmarButton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _controlador.createOrder,
        style: ElevatedButton.styleFrom(
          primary: ColorsTheme.secondaryColor,
          padding: EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 70, top: 0),
                height: 30,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
