import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'cliente_direcciones_crear_controlador.dart';

class CLienteDireccionesCrearPage extends StatefulWidget {
  const CLienteDireccionesCrearPage({Key key}) : super(key: key);

  @override
  State<CLienteDireccionesCrearPage> createState() =>
      _CLienteDireccionesCrearPageState();
}

class _CLienteDireccionesCrearPageState
    extends State<CLienteDireccionesCrearPage> {
  ClienteDireccionesCrearController _controlador =
      new ClienteDireccionesCrearController();

  bool isTimeEnabled = false;
  bool isDateEnabled = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
        title: Text('Agendar cita con agente'),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.16,
        child: Column(
          children: [_confirmarButton()],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _completaInformacion(),
              SizedBox(
                height: 40,
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(children: [
                  _textReferencia(),
                  _textDireccion(),
                  _textZona(),
                  Row(
                    children: [
                      Container(
                        child: _textHora(),
                      ),
                      Container(
                        child: _textFecha(),
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Texto Completa la información
  Widget _completaInformacion() {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 0),
      child: Text(
        'Complete la información requerida para realizar la cita con el agente inmobiliario',
        style: TextStyle(
          fontSize: 20,
          color: ColorsTheme.primaryColor,
        ),
      ),
    );
  }

// TextFlield Dirección
  Widget _textDireccion() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _controlador.direccionController,
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: ColorsTheme.primaryDarkColor,
            labelText: 'Dirección:',
            suffixIcon: Icon(
              Icons.place,
              color: ColorsTheme.secondaryColor,
            )),
        enabled:
            _controlador.areFieldsEnabled, // Habilitar el campo según el estado
      ),
    );
  }

// TextField Zona

// TextFlield Dirección
  Widget _textZona() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controlador.zonaPuntoController,
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: ColorsTheme.primaryDarkColor,
            labelText: 'Zona:',
            suffixIcon: Icon(
              Icons.location_city,
              color: ColorsTheme.secondaryColor,
            )),
        enabled: _controlador.areFieldsEnabled,
      ),
    );
  }

  // TextFlield Referencia
  Widget _textReferencia() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controlador.referenciaPuntoController,
        onTap: _controlador.openMap,
        autofocus: false,
        focusNode: AlwaysDisableFocusNode(),
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: ColorsTheme.primaryDarkColor,
            labelText: 'Abrir mapa para marcar tu ubicación:',
            suffixIcon: Icon(
              Icons.map,
              color: ColorsTheme.secondaryColor,
            )),
      ),
    );
  }

// Programar Hora

  Widget _textHora() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.34,
      margin: EdgeInsets.only(top: 10, left: 20, right: 5),
      padding: EdgeInsets.only(left: 10, right: 5),
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controlador.horaController,
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: ColorsTheme.primaryDarkColor,
            labelText: 'Hora',
            suffixIcon: Icon(
              Icons.access_time,
              color: ColorsTheme.secondaryColor,
            )),
        enabled: _controlador.areFieldsEnabled, // Usar el controlador aquí
        onTap: () async {
          final TimeOfDay timeOfDay = await showTimePicker(
            context: context,
            initialTime: selectedTime,
            initialEntryMode: TimePickerEntryMode.dial,
          );

          if (timeOfDay != null) {
            print("Hora seleccionada");
            setState(() {
              selectedTime = timeOfDay;
              _controlador.updateHora(timeOfDay); // Actualizar el controlador
            });
          }
        },
        // Resto de tu código...
      ),
    );
  }

//Programar fecha

  Widget _textFecha() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.54,
      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
      padding: EdgeInsets.only(left: 10, right: 5),
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controlador.fechaController,
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: ColorsTheme.primaryDarkColor,
            labelText: 'Fecha de Reunión:',
            suffixIcon: Icon(
              Icons.date_range,
              color: ColorsTheme.secondaryColor,
            )),
        enabled: _controlador.areFieldsEnabled, // Usar el controlador aquí
        onTap: () async {
          final DateTime dateTime = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime
                .now(), // Establecer la fecha inicial como la fecha actual
            lastDate: DateTime(2025),
          );

          if (dateTime != null) {
            print("Fecha seleccionada");
            setState(() {
              selectedDate = dateTime;
              _controlador.updateFecha(dateTime); // Actualizar el controlador
            });
          }
        },
        // Resto de tu código...
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
        onPressed: _controlador.createAddress,
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
                  'Continuar',
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

  //Boton para Seleccionar Fecha
/*
  Widget _bottonDatePicked() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 80),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.topLeft,
            child: Text(
              ' Fecha: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'NinbusSans',
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            height: 45,
            child: ElevatedButton(
              onPressed: () async {
                final DateTime dateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2025),
                );

                if (dateTime != null) {
                  print("Fecha seleccionada");
                  setState(() {
                    selectedDate = dateTime;
                  });
                }
              },
              child: Text('Seleccionar Fecha de Reunion'),
            ),
          ),
        ],
      ),
    );
  }

  //Boton para Seleccionar Fecha

  Widget _bottonTimePicked() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 80),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.topLeft,
            child: Text(
              'Hora: ${selectedTime.hour}:${selectedTime.minute}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'NinbusSans',
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            height: 45,
            child: ElevatedButton(
              onPressed: () async {
                final TimeOfDay timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                  initialEntryMode: TimePickerEntryMode.dial,
                );

                if (timeOfDay != null) {
                  print("Hora seleccionada");
                  setState(() {
                    selectedTime = timeOfDay;
                  });
                }
              },
              child: Text('Seleccionar Hora de Reunion'),
            ),
          ),
        ],
      ),
    );
  }*/

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}

class AlwaysDisableFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
