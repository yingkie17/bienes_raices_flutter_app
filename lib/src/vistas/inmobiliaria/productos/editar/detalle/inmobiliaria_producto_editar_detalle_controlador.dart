import 'dart:convert';

import 'package:bienes_raices_app/id_reports/id_reports.dart';
import 'package:bienes_raices_app/imports/imports.dart';
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
import 'dart:io';

class InmobiliariaProductosEditarDetalleController {
  BuildContext context;
  Function refresh;
  TextEditingController nombrePropietarioController =
      new TextEditingController();
  TextEditingController apellidosPropietarioController =
      new TextEditingController();
  TextEditingController telefonoPropietarioController =
      new TextEditingController();
  TextEditingController correoElectronicoPropietarioController =
      new TextEditingController();
  TextEditingController carnetIdentidadPropietarioController =
      new TextEditingController();
  TextEditingController codigoContratoPropietarioController =
      new TextEditingController();

  TextEditingController tituloPropiedadController = new TextEditingController();
  TextEditingController precioPropiedadController = new TextEditingController();
  TextEditingController comisionPropiedadController =
      new TextEditingController();
  TextEditingController ciudadPropiedadController = new TextEditingController();
  TextEditingController direccionPropiedadController =
      new TextEditingController();
  TextEditingController telefonoAgentePropiedadController =
      new TextEditingController();
  TextEditingController superficiePropiedadController =
      new TextEditingController();
  TextEditingController descripcionPropiedadController =
      new TextEditingController();

  CategoriaProvider _categoriaProvider = new CategoriaProvider();
  ProductoProvider _productoProvider = new ProductoProvider();
  Product product;
  User user;
  String idUserAgente;
  String idProductoInit;
  Idreports _idreports = new Idreports();
  ReporteProvider _reporteProvider = new ReporteProvider();
  ReportsHasReports reportsHasReports;
  SharedPref sharedPref = new SharedPref();
  List<Category> categories = [];
  String idCategory; //Almacena el id de la categoría
  PickedFile pickedFile;
  File imageProduct1;
  File imageProduct2;
  File imageProduct3;
  File imageProduct4;
  File imageProduct5;
  File imageProduct6;

  ProgressDialog _progressDialog;
  bool isEnable = true;

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    if (product != null) {
      this.product = product;
    } else {
      // Si el objeto product es nulo, puedes crear un nuevo objeto Product aquí
      this.product =
          Product(); // Asegúrate de ajustar los parámetros según tu modelo de datos
    }

    _progressDialog = new ProgressDialog(context: context);
    user = User.fromJson(await sharedPref.read('user'));
    _categoriaProvider.init(context, user);
    _productoProvider.init(context, user);
    _reporteProvider.init(context, user);
    idUserAgente = user.id.toString();
    idProductoInit = product.id;
    cargarInfoProduct();
    obtenerCategorias();

    refresh();
  }

  //Método para obtener la lista de categoria de servicios
  void obtenerCategorias() async {
    categories = await _categoriaProvider.getAll();
    refresh();
  }

  //Método para obtener la informacion del producto seleccionado en los textEditingController
  void cargarInfoProduct() async {
    nombrePropietarioController.text =
        product?.nameOwner ?? 'No Contiene información';
    apellidosPropietarioController.text =
        product?.lastnameOwner ?? 'No Contiene información';
    telefonoPropietarioController.text =
        product?.phoneOwner ?? 'No Contiene información';
    correoElectronicoPropietarioController.text =
        product?.emailOwner ?? 'No Contiene información';
    carnetIdentidadPropietarioController.text =
        product?.ciOwner ?? 'No Contiene información';
    codigoContratoPropietarioController.text =
        product?.idContract ?? 'No Contiene información';
    tituloPropiedadController.text =
        product?.nameProduct ?? 'No Contiene información';
    precioPropiedadController.text =
        product?.priceProduct.toString() ?? 'No Contiene información';
    comisionPropiedadController.text =
        product?.commissionProduct.toString() ?? 'No Contiene información';
    ciudadPropiedadController.text =
        product?.cityProduct ?? 'No Contiene información';
    direccionPropiedadController.text =
        product?.addressProduct ?? 'No Contiene información';
    telefonoAgentePropiedadController.text =
        product?.phoneProduct ?? 'No Contiene información';
    superficiePropiedadController.text =
        product?.areaProduct ?? 'No Contiene información';
    descripcionPropiedadController.text =
        product?.descriptionProduct ?? 'No Contiene información';
  }

  //Método para crear un nuevo producto
  void updateProduct() async {
    String idProducto = idProductoInit;
    String nombrePropietario = nombrePropietarioController.text;
    String apellidosPropietario = apellidosPropietarioController.text;
    String telefonoPropietario = telefonoPropietarioController.text;
    String correoElectronicoPropietario =
        correoElectronicoPropietarioController.text;
    String carnetIdentidadPropietario =
        carnetIdentidadPropietarioController.text;
    String codigoContratoPropietario = codigoContratoPropietarioController.text;
    String tituloPropiedad = tituloPropiedadController.text;
    String precioPropiedad = precioPropiedadController.text;
    String comisionPropiedad = comisionPropiedadController.text;
    String ciudadPropiedad = ciudadPropiedadController.text;
    String direccionPropiedad = direccionPropiedadController.text;
    String telefonoAgentePropiedad = telefonoAgentePropiedadController.text;
    String superficiePropiedad = superficiePropiedadController.text;
    String descripcionPropiedad = descripcionPropiedadController.text;
    if (idCategory == null) {
      // Si idCategory es null, asignar el valor de product.idCategory
      idCategory = product.idCategory;
      if (idCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Debe seleccionar una categoría de servicio'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));

        return;
      }
    }

    product.nameProduct = tituloPropiedad;
    product.priceProduct = double.parse(precioPropiedad);
    product.commissionProduct = double.parse(comisionPropiedad);
    product.cityProduct = ciudadPropiedad;
    product.addressProduct = direccionPropiedad;
    product.phoneProduct = telefonoAgentePropiedad;
    product.descriptionProduct = descripcionPropiedad;
    product.areaProduct = superficiePropiedad;
    product.nameOwner = nombrePropietario;
    product.lastnameOwner = apellidosPropietario;
    product.phoneOwner = telefonoPropietario;
    product.emailOwner = correoElectronicoPropietario;
    product.ciOwner = carnetIdentidadPropietario;
    product.idContract = codigoContratoPropietario;
    product.idCategory = idCategory;

    List<File> images = [];

    if (imageProduct1 != null) {
      images.add(imageProduct1);
    }
    if (imageProduct2 != null) {
      images.add(imageProduct2);
    }
    if (imageProduct3 != null) {
      images.add(imageProduct3);
    }
    if (imageProduct4 != null) {
      images.add(imageProduct4);
    }
    if (imageProduct5 != null) {
      images.add(imageProduct5);
    }
    if (imageProduct6 != null) {
      images.add(imageProduct6);
    }

    _progressDialog.show(
        max: 100, msg: 'Actualizando informacíon de la propiedad');

    // Stream stream = await _productoProvider.updateProduct(product, idProducto);
    Stream stream =
        await _productoProvider.updateProduct(product, idProducto, images);

    stream.listen((res) async {
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

      if (responseApi.success == true) {
        ReportsHasReports reportsHasReports = ReportsHasReports(
          idReports:
              '${_idreports.idReportActualizarProducto.toString()}', // ID del tipo de reporte para actualización de producto
          idAgent: '${idUserAgente}',
          idProduct: '${product.id}',
          nameReport: 'Actualización de Propiedad ${product.id}',
          descriptionReport:
              'Se actualizó la información de propiedad o producto,\n El agente que actualizó la información de propiedad\n Id: ${idUserAgente},\n\n ===Datos de Agente=== \n\n Nombre: ${user.name},\n Apellidos: ${user.lastname},\n Correo Electrónico: ${user.email},\n Teléfono: ${user.phone},\n\n ===Datos de Propiedad o Producto===\n\n  Título: ${product.nameProduct},\n Descripción: ${product.descriptionProduct},\n Precio: ${product.priceProduct},\n Comisión: ${product.commissionProduct},\n Dirección: ${product.addressProduct},\n Área:${product.areaProduct},\n Agente Celular: ${product.phoneProduct},\n\n ===Datos de Propietario=== \n\n Nombre: ${product.nameOwner},\n Apeliidos: ${product.lastnameOwner},\n Teléfono: ${product.phoneOwner},\n Correp Electrónico: ${product.emailOwner},\n Carnet Identidad: ${product.ciOwner},\n Código Contrato: ${product.idContract},\n Categoría: ${product.idCategory}',
        );

        ResponseApi reportResponse =
            await _reporteProvider.addReport(reportsHasReports);
        if (reportResponse.success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${reportResponse.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.lightGreen[900],
          ));
          print('Se ha guardado el reporte: ${reportResponse.message}');
        } else {
          print(
              'Ha ocurrido un error en metodo generar reporte: ${reportResponse.message}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${reportResponse.message}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[600],
          ));
          print('Error al guardar el reporte: ${reportResponse.message}');
          _progressDialog.close();
          return;
        }
        print('La actualizacion fue exitosa: ${responseApi.message}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${responseApi.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.lightGreen[900],
        ));
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context, true);
        });
      } else {
        print(
            'Ha ocurrido un error en metodo generar reporte: ${responseApi.message}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${responseApi.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
        _progressDialog.close();
        return;
      }

      print('Se ha saltado hasta esta parte el codigi');

      Navigator.pop(context, true);
      Navigator.pushNamedAndRemoveUntil(
          context, 'inmobiliaria/propiedades/list', (route) => false);

      Future.delayed(Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${responseApi.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.lightGreen[900],
        ));
      });
    });
  }

  //Método para seleccionar imagen
  Future selectImage(ImageSource imageSource, int numberFile) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      if (numberFile == 1) {
        // Se esta almacenando la imagen 1
        imageProduct1 = File(pickedFile.path);
      } else if (numberFile == 2) {
        // Se esta almacenando la imagen 2
        imageProduct2 = File(pickedFile.path);
      } else if (numberFile == 3) {
        // Se esta almacenando la imagen 3
        imageProduct3 = File(pickedFile.path);
      } else if (numberFile == 4) {
        // Se esta almacenando la imagen 4
        imageProduct4 = File(pickedFile.path);
      } else if (numberFile == 5) {
        // Se esta almacenando la imagen 5
        imageProduct5 = File(pickedFile.path);
      } else if (numberFile == 6) {
        // Se esta almacenando la imagen 6
        imageProduct6 = File(pickedFile.path);
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

  void close() {
    Navigator.pop(context);
  }

  //Metodo para vaciar campos

  void resetValues() {
    tituloPropiedadController.text = '';
    precioPropiedadController.text = '';
    comisionPropiedadController.text = '';
    ciudadPropiedadController.text = '';
    direccionPropiedadController.text = '';
    telefonoAgentePropiedadController.text = '';
    descripcionPropiedadController.text = '';
    superficiePropiedadController.text = '';
    nombrePropietarioController.text = '';
    apellidosPropietarioController.text = '';
    telefonoPropietarioController.text = '';
    correoElectronicoPropietarioController.text = '';
    carnetIdentidadPropietarioController.text = '';
    codigoContratoPropietarioController.text = '';

    imageProduct1 = null;
    imageProduct2 = null;
    imageProduct3 = null;
    imageProduct4 = null;
    imageProduct5 = null;
    imageProduct6 = null;
    idCategory = null;
    refresh();
  }
}
