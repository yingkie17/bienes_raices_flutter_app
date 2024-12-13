import 'dart:convert';
import 'package:bienes_raices_app/id_reports/id_reports.dart';
import 'package:bienes_raices_app/imports/imports.dart';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/modelos/categoria_model.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/categoria_provider.dart';
import 'package:bienes_raices_app/src/provider/producto_provider.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class InmobiliariaProductosCrearControlador {
  BuildContext context;
  Function refresh;
  TextEditingController nombreProductoController = new TextEditingController();
  TextEditingController precioProductoController = new TextEditingController();
  TextEditingController comisionProductoiaController =
      new TextEditingController();
  TextEditingController ciudadProductoiaController =
      new TextEditingController();
  TextEditingController direccionProductoiaController =
      new TextEditingController();
  TextEditingController celularProductoiaController =
      new TextEditingController();
  TextEditingController descripcionProductoiaController =
      new TextEditingController();
  TextEditingController superficieProductoiaController =
      new TextEditingController();
  TextEditingController nombrePropietarioProductoiaController =
      new TextEditingController();

  TextEditingController apellidosPropietarioController =
      new TextEditingController();
  TextEditingController celularPropietarioController =
      new TextEditingController();
  TextEditingController correoPropietarioprecioController =
      new TextEditingController();
  TextEditingController carnetIdentidadPropietarioController =
      new TextEditingController();
  TextEditingController numContratoPropietarioController =
      new TextEditingController();
  String idUserAgente;
  CategoriaProvider _categoriaProvider = new CategoriaProvider();
  ProductoProvider _productoProvider = new ProductoProvider();
  ReporteProvider _reporteProvider = new ReporteProvider();
  User user;

  ReportsHasReports reportsHasReports;

  SharedPref sharedPref = new SharedPref();
  List<Category> categories = [];
  String idCategory; //Almacena el id de la categoría
  PickedFile pickedFile;
  File imageFile1;
  File imageFile2;
  File imageFile3;
  File imageFile4;
  File imageFile5;
  File imageFile6;

  Idreports _idreports = new Idreports();

  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = new ProgressDialog(context: context);
    user = User.fromJson(await sharedPref.read('user'));
    _categoriaProvider.init(context, user);
    _productoProvider.init(context, user);
    _reporteProvider.init(context, user);
    idUserAgente = user.id;
    obtenerCategorias();
  }

  //Método para obtener la lista de categoria de servicios
  void obtenerCategorias() async {
    categories = await _categoriaProvider.getAll();
    refresh();
  }

  //Método para crear un nuevo producto
  //Método para crear un nuevo producto
  void crearProducto() async {
    String nombreProducto = nombreProductoController.text;
    String precioProducto = precioProductoController.text.toString();
    String comisionProducto = comisionProductoiaController.text;
    String ciudadProducto = ciudadProductoiaController.text;
    String direccionProducto = direccionProductoiaController.text;
    String celularProducto = celularProductoiaController.text;
    String descripcionProducto = descripcionProductoiaController.text;
    String superficieProducto = superficieProductoiaController.text;
    String nombrePropietarioProducto =
        nombrePropietarioProductoiaController.text;
    String apellidosPropietarioProducto = apellidosPropietarioController.text;
    String celularPropietarioProducto = celularPropietarioController.text;
    String correoPropietarioProducto = correoPropietarioprecioController.text;
    String carnetIdentidadPropietarioProducto =
        carnetIdentidadPropietarioController.text;
    String numContratoPropietarioProducto =
        numContratoPropietarioController.text;

    if (nombreProducto.isEmpty ||
        precioProducto.isEmpty ||
        comisionProducto.isEmpty ||
        ciudadProducto.isEmpty ||
        direccionProducto.isEmpty ||
        celularProducto.isEmpty ||
        descripcionProducto.isEmpty ||
        superficieProducto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Debe ingresar la informacion de la propiedad o producto en todos los campos requeridos'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }
    if (nombrePropietarioProducto.isEmpty ||
        apellidosPropietarioProducto.isEmpty ||
        celularPropietarioProducto.isEmpty ||
        carnetIdentidadPropietarioProducto.isEmpty ||
        numContratoPropietarioProducto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Debe ingresar la información del Propietario en los campos requeridos'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));

      return;
    }
    if (idCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe seleccionar una categoria de servicio'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }
    if (imageFile1 == null ||
        imageFile2 == null ||
        imageFile3 == null ||
        imageFile4 == null ||
        imageFile5 == null ||
        imageFile6 == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Debe seleccionar 6 imagenes imagenes de la propiedad'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));

      return;
    }
    Product product = new Product(
      nameProduct: nombreProducto,
      priceProduct: double.parse(precioProducto),
      commissionProduct: double.parse(comisionProducto),
      cityProduct: ciudadProducto,
      addressProduct: direccionProducto,
      phoneProduct: celularProducto,
      descriptionProduct: descripcionProducto,
      areaProduct: superficieProducto,
      nameOwner: nombrePropietarioProducto,
      lastnameOwner: apellidosPropietarioProducto,
      phoneOwner: celularPropietarioProducto,
      emailOwner: correoPropietarioProducto,
      ciOwner: carnetIdentidadPropietarioProducto,
      idContract: numContratoPropietarioProducto,
      idCategory: idCategory,
    );
    List<File> images = [];

    images.add(imageFile1);
    images.add(imageFile2);
    images.add(imageFile3);
    images.add(imageFile4);
    images.add(imageFile5);
    images.add(imageFile6);

    _progressDialog.show(
        max: 100, msg: 'Procesando Registro de nueva propiedad');
    Stream stream = await _productoProvider.create(product, images);
    stream.listen((res) async {
      print(res);
      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${responseApi.message}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen[900],
      ));

      if (responseApi.success == true) {
        ReportsHasReports reportsHasReports = ReportsHasReports(
          idReports:
              '${_idreports.idReportCrearProducto.toString()}', // ID del tipo de reporte para actualización de producto
          idUser: null,
          idAgent: '${idUserAgente}',
          nameReport: 'Creación de Propiedad o Producto ',
          descriptionReport:
              'Se creó nueva propiedad o producto,\n El agente que restró la nueva propiedad Id: ${idUserAgente},\n\n ===Datos de Agente=== \n\n Nombre: ${user.name},\n Apellidos: ${user.lastname},\n Correo Electrónico: ${user.email},\n Teléfono: ${user.phone},\n\n ===Datos de Propiedad o Producto===\n\n  Título: ${product.nameProduct},\n Descripción: ${product.descriptionProduct},\n Precio: ${product.priceProduct},\n Comisión: ${product.commissionProduct},\n Dirección: ${product.addressProduct},\n Área:${product.areaProduct},\n Agente Celular: ${product.phoneProduct},\n\n ===Datos de Propietario=== \n\n Nombre: ${product.nameOwner},\n Apeliidos: ${product.lastnameOwner},\n Teléfono: ${product.phoneOwner},\n Correp Electrónico: ${product.emailOwner},\n Carnet Identidad: ${product.ciOwner},\n Código Contrato: ${product.idContract},\n Categoría: ${product.idCategory}',
        );

        ResponseApi reportResponse =
            await _reporteProvider.addReport(reportsHasReports);
        if (reportResponse.success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${reportResponse.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.lightGreen[900],
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${reportResponse.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[600],
          ));
          _progressDialog.close();
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${responseApi.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.lightGreen[900],
        ));
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context, true);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${responseApi.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
        _progressDialog.close();
        return;
      }
    });
  }

  //Metodo para vaciar campos

  void resetValues() {
    nombreProductoController.text = '';
    precioProductoController.text = '';
    comisionProductoiaController.text = '';
    ciudadProductoiaController.text = '';
    direccionProductoiaController.text = '';
    celularProductoiaController.text = '';
    descripcionProductoiaController.text = '';
    superficieProductoiaController.text = '';
    nombrePropietarioProductoiaController.text = '';
    apellidosPropietarioController.text = '';
    celularPropietarioController.text = '';
    correoPropietarioprecioController.text = '';
    carnetIdentidadPropietarioController.text = '';
    numContratoPropietarioController.text = '';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    imageFile4 = null;
    imageFile5 = null;
    imageFile6 = null;
    idCategory = null;
    refresh();
  }

  //Método para seleccionar imagen
  Future selectImage(ImageSource imageSource, int numberFile) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      if (numberFile == 1) {
        // Se esta almacenando la imagen 1
        imageFile1 = File(pickedFile.path);
      } else if (numberFile == 2) {
        // Se esta almacenando la imagen 2
        imageFile2 = File(pickedFile.path);
      } else if (numberFile == 3) {
        // Se esta almacenando la imagen 3
        imageFile3 = File(pickedFile.path);
      } else if (numberFile == 4) {
        // Se esta almacenando la imagen 4
        imageFile4 = File(pickedFile.path);
      } else if (numberFile == 5) {
        // Se esta almacenando la imagen 5
        imageFile5 = File(pickedFile.path);
      } else if (numberFile == 6) {
        // Se esta almacenando la imagen 6
        imageFile6 = File(pickedFile.path);
      }
    }
    Navigator.pop(context);

    refresh();
  }

  //Método para mostrar cuadro de dialogo para seleccionar una opcion de cámara o galeria
  void showAlertDialog(int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('Galería'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera, numberFile);
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
}
