import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/direccion_modelo.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/address_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:bienes_raices_app/src/vistas/cliente/direcciones/mapa/cliente_direcciones_mapa_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';

class ClienteDireccionesCrearController {
  BuildContext context;
  Function refresh;

  bool isMapSelected =
      false; // Estado para controlar si se seleccionó la dirección en el mapa
  bool areFieldsEnabled =
      false; // Estado para controlar si los campos están habilitados     // Estado para controlar si se seleccionó la dirección en el mapa
  TextEditingController referenciaPuntoController = new TextEditingController();
  TextEditingController direccionController = new TextEditingController();
  TextEditingController zonaPuntoController = new TextEditingController();
  TextEditingController fechaController = new TextEditingController();
  TextEditingController horaController = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Map<String, dynamic> puntoReferencia;

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProvider.init(context, user);
  }

  void createAddress() async {
    if (!isMapSelected) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe marcar la dirección en el mapa primero'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }
    if (puntoReferencia == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe marcar la dirección en el mapa primero'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }
    String direccion = direccionController.text;
    String zona = zonaPuntoController.text;
    double lat = puntoReferencia != null ? puntoReferencia['lat'] : null;
    double lng = puntoReferencia != null ? puntoReferencia['lng'] : null;
    DateTime fecha;
    TimeOfDay hora;

    if (lat == null || lng == null || lat == 0 || lng == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Debe marcar la dirección para la reunión con el agente inmobiliario',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }
    if (fechaController.text.isNotEmpty) {
      try {
        fecha = DateTime.parse(fechaController.text);
        // Validar fecha futura
        if (fecha.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('La fecha debe ser hoy o en el futuro'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red[600],
            ),
          );
          return;
        }
      } catch (e) {
        print('Error al parsear la fecha: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Formato de fecha no válido'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
        return;
      }
    }
    if (horaController.text.isNotEmpty) {
      try {
        hora = TimeOfDay.fromDateTime(
            DateFormat('HH:mm').parse(horaController.text));
      } catch (e) {
        print('Error al parsear la hora: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Formato de hora no válido'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
        return;
      }
    }

    if (fecha == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Debe ingresar la fecha para la reunión con el agente inmobiliario',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }

    Address address = new Address(
        address: direccion,
        neighborhood: zona,
        lat: lat,
        lng: lng,
        dateEvent: fecha,
        timeEvent: hora,
        idUser: user.id);
    ResponseApi responseApi = await _addressProvider.create(address);
    refresh();

    if (responseApi.success) {
      await _sharedPref.save('address', address.toJson());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${responseApi.message}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen[900],
      ));
      Navigator.pop(context, true);
    }
  }

  void openMap() async {
    puntoReferencia = await showMaterialModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      builder: (context) => ClienteDireccionesMapaPage(),
    );
    if (puntoReferencia != null) {
      referenciaPuntoController.text = puntoReferencia['address'];
      selectPuntoReferencia(); // Llamar a selectPuntoReferencia después de seleccionar una dirección en el mapa
    }
  }

  void updateFecha(DateTime selectedDate) {
    print('Fecha seleccionada: $selectedDate');
    fechaController.text =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
  }

  void updateHora(TimeOfDay selectedTime) {
    print('Hora seleccionada: $selectedTime');
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    DateFormat format = DateFormat.Hm(); // Formato de hora y minutos

    horaController.text = format.format(dateTime);
  }

  void selectPuntoReferencia() async {
    if (puntoReferencia != null) {
      referenciaPuntoController.text = puntoReferencia['address'];
      isMapSelected =
          true; // Marcar como verdadero cuando se seleccione la dirección en el mapa
      areFieldsEnabled = true; // Habilitar los otros campos

      // Implementar la validación para evitar el error de split en un valor nulo
      if (referenciaPuntoController.text != null) {
        referenciaPuntoController.text
            .split(''); // Corregir el separador dentro de split
      }

      refresh(); // Actualizar la interfaz de usuario
    }
  }
}
