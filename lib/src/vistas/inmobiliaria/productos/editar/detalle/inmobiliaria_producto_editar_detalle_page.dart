import 'package:bienes_raices_app/imports/imports.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/productos/editar/detalle/inmobiliaria_producto_editar_detalle_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:bienes_raices_app/src/modelos/categoria_model.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'dart:io';

class InmobiliariaProductosEditarDetallePage extends StatefulWidget {
  Product product;

  InmobiliariaProductosEditarDetallePage({Key key, @required this.product})
      : super(key: key);

  @override
  State<InmobiliariaProductosEditarDetallePage> createState() =>
      _InmobiliariaProductosEditarDetallePageState();
}

class _InmobiliariaProductosEditarDetallePageState
    extends State<InmobiliariaProductosEditarDetallePage> {
  InmobiliariaProductosEditarDetalleController _controlador =
      new InmobiliariaProductosEditarDetalleController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controlador.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Column(
            children: [
//=========================================== Nuevo =========================//
              _imageSlideshow(),
              _tituloInformacionPropietario(),
              SizedBox(
                height: 15,
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    _textFielNombrePropietario(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielApellidosPropietario(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielTelefonoPropietario(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielCorreoElectronicoPropietario(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielCarnetIdentidadPropietario(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielCodigoContratodPropietario(),
                    SizedBox(
                      height: 30,
                    ),
                    _tituloInformacionPropiedad(),
                    SizedBox(
                      height: 30,
                    ),
                    _categoriaServicioProducto(_controlador.categories),
                    SizedBox(
                      height: 30,
                    ),
                    _textFieltituloPropiedad(),
                    SizedBox(
                      height: 20,
                    ),
                    _textFielPrecioPropiedad(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielComisionPropiedad(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielCiudadPropiedad(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielDireccionPropiedad(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielTelefonoPropiedad(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielSuperficiePropiedad(),
                    SizedBox(
                      height: 10,
                    ),
                    _textFielDescripcionPropiedad(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _tarjetaImagen(_controlador.imageProduct1, 1),
                            _tarjetaImagen(_controlador.imageProduct2, 2),
                            _tarjetaImagen(_controlador.imageProduct3, 3),
                          ]),
                    ),
                    Container(
                      height: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _tarjetaImagen(_controlador.imageProduct4, 4),
                          _tarjetaImagen(_controlador.imageProduct5, 5),
                          _tarjetaImagen(_controlador.imageProduct6, 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              _actualizarProductoBoton(),
              SizedBox(height: 15),

              ////////
            ],
          ),
        ));
  }

//método de Título de Fomrulario
  Widget _tituloInformacionPropietario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      margin: EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              'Editar Información de ',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.normal,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
          Container(
            child: Text(
              'Propietario',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Método de campo de nombre propietario
  Widget _textFielNombrePropietario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Nombre propietario:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.nombrePropietarioController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Ingresar nombre de propietario',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.person,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo de apellido propietario
  Widget _textFielApellidosPropietario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Apellidos propietario:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.apellidosPropietarioController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Ingresar apellidos de propietario',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.person_outline_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo de teléfono propietario
  Widget _textFielTelefonoPropietario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Teléfono propietario:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.telefonoPropietarioController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Ingresar teléfono de Propietario',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.phone_android_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

//Método de campo de correo electrónico propietario
  Widget _textFielCorreoElectronicoPropietario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Correo electrónco propietario:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.correoElectronicoPropietarioController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Ingresar E-mail de propietario',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

              RegExp regExp = new RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Correo electrónico no es válido';
            },
          ),
        ),
      ],
    );
  }

  //Método de campo de carnet de identidad propietario
  Widget _textFielCarnetIdentidadPropietario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Documento identidad propietario:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.carnetIdentidadPropietarioController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Documento identidad propietario',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.card_membership_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo código de contrato propietario
  Widget _textFielCodigoContratodPropietario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Código de contrato:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.codigoContratoPropietarioController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Ingresar código de contrato propietario',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.insert_drive_file_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

//método de Título de Fomrulario
  Widget _tituloInformacionPropiedad() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              'Editar Información de ',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.normal,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
          Container(
            child: Text(
              'Propiedad',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Método de Campo título propiedad
  Widget _textFieltituloPropiedad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Título de Propiedad:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.tituloPropiedadController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Título de propiedad',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.list_alt_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo título propiedad
  Widget _textFielPrecioPropiedad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Precio de Propiedad:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.precioPropiedadController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Precio de propiedad',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.monetization_on_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo comisión propiedad
  Widget _textFielComisionPropiedad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Comisión de Propiedad:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.comisionPropiedadController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Comisión de propiedad',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.attach_money_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo ciudad propiedad
  Widget _textFielCiudadPropiedad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Ciudad de Propiedad:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.ciudadPropiedadController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Ciudad de propiedad',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.map_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo dirección propiedad
  Widget _textFielDireccionPropiedad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Dirección de Propiedad:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.direccionPropiedadController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Dirección de propiedad',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.place_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo dirección propiedad
  Widget _textFielTelefonoPropiedad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Teléfono de Propiedad:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.telefonoAgentePropiedadController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Teléfono de propiedad',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.phone_android_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo superficie propiedad
  Widget _textFielSuperficiePropiedad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Superficie de Propiedad:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.superficiePropiedadController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Superficie de propiedad',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.yard_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Método de campo descripción propiedad
  Widget _textFielDescripcionPropiedad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'Descripción de Propiedad:',
            style: TextStyle(
              color: ColorsTheme.primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorsTheme.primaryOpacityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            //
            controller: _controlador.descripcionPropiedadController,
            maxLength: 455,
            maxLines: 8,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
              hintText: 'Descripción de propiedad',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.description_outlined,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Método Carrusel de Imagenes  Ventana Modal
  Widget _imageSlideshow() {
    return Stack(
      children: [
        ImageSlideshow(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          initialPage: 0,
          indicatorColor: ColorsTheme.secondaryColor,
          indicatorBackgroundColor: Colors.grey,
          children: [
            FadeInImage(
              image: _controlador.product?.imageProduct1 != null
                  ? NetworkImage(_controlador.product.imageProduct1)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct2 != null
                  ? NetworkImage(_controlador.product.imageProduct2)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct3 != null
                  ? NetworkImage(_controlador.product.imageProduct3)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct4 != null
                  ? NetworkImage(_controlador.product.imageProduct4)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct5 != null
                  ? NetworkImage(_controlador.product.imageProduct5)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct6 != null
                  ? NetworkImage(_controlador.product.imageProduct6)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
          ],
          onPageChanged: (value) {
            print('Página Cambiada: $value');
          },
          autoPlayInterval: 70000,
          isLoop: true,
        ),

        // Back Arrow ir Atrás
        Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              onPressed: _controlador.close,
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white70,
            ))
      ],
    );
  }

  //Metodo para tarjetas de imagenes

  //Método para agregar Imagenes

  Widget _tarjetaImagen(File imageProduct, int numberFile) {
    return GestureDetector(
      onTap: () {
        _controlador.showAlertDialog(numberFile);
      },
      child: imageProduct != null
          ? Card(
              elevation: 4.0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.26,
                height: 150,
                child: Image.file(
                  imageProduct,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Card(
              elevation: 3.0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.26,
                height: 140,
                child: Image(
                  image: AssetImage('lib/assets/images/add_image.png'),
                ),
              ),
            ),
    );
  }

//Método prueba para validacion

  //Método para crear menu de categorias desplegables

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: Text(
          category.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsTheme.primaryColor,
          ),
        ),
        value: category.id,
      ));
    });
    return list;
  }

  //Método de campo de categoria de servicios
  Widget _categoriaServicioProducto(List<Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: ColorsTheme.primaryColor,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Tipo de servicio',
                    style: TextStyle(
                        fontSize: 16, color: ColorsTheme.primaryDarkColor),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: ColorsTheme.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                      '${_controlador.product?.idCategory ?? 'Selccioné una categoria servicio'}'),
                  items: _dropDownItems(categories),
                  value: _controlador.idCategory,
                  onChanged: (option) {
                    setState(() {
                      print('Categoria seleccionada: $option');
                      _controlador.idCategory = option;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//Método para actualizar Información
  Widget _actualizarProductoBoton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Confirmación'),
                    content: Text(
                        '¿Estás seguro de actualizar la información de la propiedad?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: _controlador.updateProduct,
                        child: Text('Aceptar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      )
                    ]);
              });
        },
        child: Text('Actualizar Propiedad'),
        style: ElevatedButton.styleFrom(
            primary: ColorsTheme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
