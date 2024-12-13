import 'dart:convert';
import 'dart:io';
import 'package:bienes_raices_app/id_reports/id_reports.dart';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/provider/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RegistroControlador {
  BuildContext context;

// Se llama a los Textfields del registro vista

  TextEditingController nombreController = new TextEditingController();
  TextEditingController apellidosController = new TextEditingController();
  TextEditingController correoController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  TextEditingController contrasenaController = new TextEditingController();
  TextEditingController validarContrasenaController =
      new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();
  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable = true;
  User user;
  Idreports _idreports = new Idreports();
  ReporteProvider _reporteProvider = ReporteProvider();
  ReportsHasReports reportsHasReports;
  Future init(BuildContext context, Function refresh) {
    this.refresh = refresh;
    this.context = context;
    usersProvider.init(context); // Crear una nueva instancia de ReporteProvider
    _reporteProvider.init(context, user);
    _progressDialog = ProgressDialog(context: context);
  }

  //Metodo para registrar Usuario
  void registrar() async {
    String name = nombreController.text;
    String lastname = apellidosController.text;
    String email = correoController.text.trim();
    String phone = telefonoController.text.trim();
    String password = contrasenaController.text.trim();
    String confirmpassword = validarContrasenaController.text.trim();

    //validamos los campos agragando un controlador

    if (name.isEmpty ||
        lastname.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe llenar todos los campos'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));

      return;
    }
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

    isEnable = false;
    User user = new User(
        name: name,
        lastname: lastname,
        email: email,
        phone: phone,
        password: password);
    _progressDialog.show(max: 100, msg: 'Procesando Registro de usuario');
    //Método de crear con Imagen
    Stream stream = await usersProvider.createWithImage(user, imageFile);
    stream.listen((res) async {
      // ResponseApi responseApi = await usersProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

      if (responseApi.success) {
        _progressDialog.close();
        ReportsHasReports reportsHasReports = ReportsHasReports(
          idReports:
              '${_idreports.idReportCreacionCliente.toString()}', // ID del tipo de reporte para actualización de producto
          idUser: null,
          idProduct: null,
          nameReport:
              'Creación de nuevo cliente: ${user.name}, ${user.lastname}',
          descriptionReport:
              'Se realizó el registro de nuevo cliente,\n\n ===Datos de Nuevo Cliente===\n\n  Nombre: ${user.name},\n Apellidos: ${user.lastname},\n E-mail: ${user.email},\n Teléfono: ${user.phone} ',
        );
        ResponseApi reportResponse =
            await _reporteProvider.addReportRegisterClient(reportsHasReports);
        if (reportResponse.success) {
          print('Se generó reporte de registro de nuevo usuario');
        } else {
          _progressDialog.close();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error al generar el reporte de la actualización del producto, ${responseApi.error}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[600],
          ));
        }
        _progressDialog.close();
        Future.delayed(Duration(milliseconds: 200), () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${responseApi.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.lightGreen[900],
          ));

          Navigator.pushReplacementNamed(context, 'login');
        });
      } else {
        _progressDialog.close();
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

  void backpage() {
    Navigator.pop(context);
  }
}
