import 'dart:convert';
import 'dart:io';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/users_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ClienteModificarUsuarioControlador {
  BuildContext context;

// Se llama a los Textfields del registro vista

  TextEditingController nombreController = new TextEditingController();
  TextEditingController apellidosController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();
  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable = true;
  //Editar Perfil se cargara la información de usuario del sharedPref
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.refresh = refresh;
    this.context = context;
    _progressDialog = ProgressDialog(context: context);
    //metodo para editar perfil
    user = User.fromJson(await _sharedPref.read('user'));
    usersProvider.init(context,
        sessionUser:
            user); // Si el Token es diferente la sesión se cierra por que se envio un token diferente
    nombreController.text = user.name;
    apellidosController.text = user.lastname;
    telefonoController.text = user.phone;
    refresh();
  }

  //Metodo para editar perfil de usuario
  void update() async {
    String name = nombreController.text;
    String lastname = apellidosController.text;
    String phone = telefonoController.text.trim();

    //validamos los campos agragando un controlador

    if (name.isEmpty || lastname.isEmpty || phone.isEmpty) {
      MySnackbar.show(context, 'Debe llenar todos los campos');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Procesando el Registro...');
    isEnable = false;

    User myUser = new User(
      id: user.id,
      name: name,
      lastname: lastname,
      phone: phone,
      image: user.image,
    );

    //Método de actualizar perfil con imagen
    Stream stream = await usersProvider.update(myUser, imageFile);
    stream.listen((res) async {
      _progressDialog.close();
      // ResponseApi responseApi = await usersProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      MySnackbar.show(context, responseApi.message);
      if (responseApi.success) {
        user = await usersProvider
            .getById(myUser.id); //Obteniendo el usuario de la base de datos
        _sharedPref.save('user', user.toJson());
        Navigator.pushNamedAndRemoveUntil(
            context, 'cliente/propiedades/list', (route) => false);
      } else {
        isEnable = true;
      }
    });
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      // Con esto enviamos a node Js para que almacene nuestra imagen
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);

    refresh();
  }

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
