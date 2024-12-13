import 'dart:convert';
import 'dart:io';
import 'package:bienes_raices_app/id_reports/id_reports.dart';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/provider/users_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:intl/intl.dart';

class InmobiliariaRegristrarNuevoAgenteControlador {
  BuildContext context;

// Se llama a los Textfields del registro vista

  TextEditingController nombreController = new TextEditingController();
  TextEditingController apellidosController = new TextEditingController();
  TextEditingController carnetIdentidadController = new TextEditingController();
  TextEditingController correoController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  TextEditingController direccionController = new TextEditingController();
  TextEditingController fechaNacimientoController = new TextEditingController();
  TextEditingController lugarNacimientoController = new TextEditingController();
  TextEditingController contrasenaController = new TextEditingController();
  TextEditingController validarContrasenaController =
      new TextEditingController();
  TextEditingController experienciaController = new TextEditingController();
  TextEditingController certificacionesController = new TextEditingController();
  TextEditingController formacionProfesionalController =
      new TextEditingController();
  TextEditingController fechaIncioTrabajoController =
      new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();
  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  User user;
  String idUserAgente;
  String nombreAgente;
  String apellidoAgente;
  String emailAgente;
  String celularAgente;
  ReporteProvider _reporteProvider = new ReporteProvider();
  ReportsHasReports reportsHasReports;
  SharedPref _sharedPref = new SharedPref();
  Idreports _idreports = new Idreports();

  Future init(BuildContext context, Function refresh) async {
    this.refresh = refresh;
    this.context = context;
    usersProvider.init(context);
    user = User.fromJson(await _sharedPref.read('user'));

    usersProvider.init(context, sessionUser: user);
    _progressDialog = ProgressDialog(context: context);
    _reporteProvider.init(context, user);
    idUserAgente = user.id;
    nombreAgente = user.name;
    apellidoAgente = user.lastname;
    emailAgente = user.email;
    celularAgente = user.phone;
  }

  //Metodo para registrar Usuario
  void registrar() async {
    String name = nombreController.text;
    String lastname = apellidosController.text;
    String identity_card = carnetIdentidadController.text.trim();
    String email = correoController.text.trim();
    String phone = telefonoController.text.trim();
    String address_agent = direccionController.text;
    String date_of_birth = fechaNacimientoController.text;
    String place_of_birth = lugarNacimientoController.text;
    String password = contrasenaController.text.trim();
    String confirmpassword = validarContrasenaController.text.trim();
    String experience = experienciaController.text;
    String certificates = certificacionesController.text;
    String area_specialist = formacionProfesionalController.text;
    String date_of_entry = fechaIncioTrabajoController.text;
    // Convertir las fechas al formato YYYY-MM-DD

    //validamos los campos agragando un controlador

    if (name.isEmpty ||
        lastname.isEmpty ||
        identity_card.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        address_agent.isEmpty ||
        place_of_birth.isEmpty ||
        experience.isEmpty ||
        certificates.isEmpty ||
        area_specialist.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe llenar todos los campos'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));

      return;
    }

    if (date_of_birth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe ingresar la fecha de nacimiento'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }
    if (date_of_birth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe ingresar la fecha de inicio de trabajo'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }

    String dateOfBirth = formatDate(fechaNacimientoController.text);
    String dateOfEntry = formatDate(fechaIncioTrabajoController.text);
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La contraseña debe contener almenos 6 digitos'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));

      return;
    }

    if (confirmpassword != password) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'La contraseña no coincide con el campo de confirmación de contraseña'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));

      return;
    }
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Seleccione una Imagen'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));

      return;
    }

    User user = new User(
        name: name,
        lastname: lastname,
        identity_card: identity_card,
        email: email,
        phone: phone,
        address_agent: address_agent,
        date_of_birth: dateOfBirth,
        place_of_birth: place_of_birth,
        experience: experience,
        certificates: certificates,
        area_specialist: area_specialist,
        date_of_entry: dateOfEntry,
        password: password);

    //_progressDialog.show(max: 100, msg: 'Registrando Agente...');

    //Método de crear con Imagen
    Stream stream = await usersProvider.createAgent(user, imageFile);
    stream.listen((res) async {
      // ResponseApi responseApi = await usersProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

      if (responseApi.success == true) {
        // Registro del agente exitoso, ahora generamos el reporte
        ReportsHasReports reportsHasReports = ReportsHasReports(
          idReports: '${_idreports.idReportCrearAgente.toString()}',
          idAgent: '${idUserAgente}',
          idProduct: null,
          nameReport: 'Registro nuevo agente inmobiliario,',
          descriptionReport:
              'Se registró un nuevo agente inmobiliario,\n\n === Datos de Agente que Realizó el Registro de Nuevo Agente === \n\n Id: $idUserAgente,\n Nombre: $nombreAgente,\n Apellidos: $apellidoAgente,\n E-mail: $emailAgente,\n Celular: $celularAgente, \n\n === Datos de Registro de nuevo Agente=== \n\n Nombre NA: ${user.name},\n Apellidos NA: ${user.lastname},\n Carnet identidad NA: ${user.identity_card},\n E-mail NA: ${user.email},\n Celular NA: ${user.phone},\n Dirección NA: ${user.address_agent},\n Fecha Nacimiento NA: ${user.date_of_birth},\n Lugar Nacimiento NA: ${user.place_of_birth},\n Experiencia Laboral NA: ${user.experience},\n Certificaciones NA: ${user.certificates},\n Formación Profesional NA: ${user.area_specialist},\n Fecha Inicio de Trabajo NA: ${user.date_of_entry}',
        );

        ResponseApi reportResponse =
            await _reporteProvider.addReport(reportsHasReports);
        if (reportResponse.success) {
          // Generación de reporte exitosa
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Se ha generado un reporte al registrar nuevo agente inmobiliario, ${reportResponse.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.lightGreen[900],
          ));
        } else {
          // Error al generar el reporte
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error al generar el reporte al registrar un nuevo agente inmobiliario, error: ${reportResponse.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[600],
          ));
          _progressDialog.close();
          return;
        }

        // Mostrar mensaje de éxito del registro del agente
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${responseApi.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.lightGreen[900],
        ));
        // Navegar a otra pantalla después de completar el registro y el reporte
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
              context, 'inmobiliaria/propiedades/list', (route) => false);
        });
      } else {
        _progressDialog.close();
        // Error en el registro del agente
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${responseApi.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
      }
    });
  }

  //Método para seleccionar imagen
  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      // Con esto enviamos a node Js para que almacene nuestra imagen
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);

    refresh();
  }

  //Método para mostrar cuadro de dialogo para seleccionar una opcion de cámara o galeria
  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('Galería'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('Cámara'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Seleccione una Imagen'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  // Método para formatear la fecha al formato YYYY-MM-DD
  String formatDate(String date) {
    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    return formattedDate;
  }

  void backpage() {
    Navigator.pop(context);
  }
}
