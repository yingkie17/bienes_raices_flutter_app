import 'package:flutter/material.dart';
import 'package:bienes_raices_app/imports/imports.dart';
import 'package:flutter/scheduler.dart';

import 'inmobiliaria_categoria_crear_controlador.dart';

class InmobiliariaCategoriaCrearPage extends StatefulWidget {
  const InmobiliariaCategoriaCrearPage({Key key}) : super(key: key);

  @override
  State<InmobiliariaCategoriaCrearPage> createState() =>
      _InmobiliariaCategoriaCrearPageState();
}

class _InmobiliariaCategoriaCrearPageState
    extends State<InmobiliariaCategoriaCrearPage> {
  InmobiliariaCategoriaCrearControlador _controlador =
      new InmobiliariaCategoriaCrearControlador();

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
        centerTitle: true,
        title: Text('Crear nueva categoria'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            _imageBuldingApp(),
            _textInformacion(),
            _textFieldNombreCategoria(),
            SizedBox(
              height: 15,
            ),
            _textFieldDescripcionCategoria(),
          ],
        ),
      ),
      bottomNavigationBar: _crearNuevaCategoriaBoton(),
    );
  }

  // Méetodo Logo contenedor
  Widget _logoContainer() {
    final _size = MediaQuery.of(context).size;
    return Container(
      child: Image.asset(
        'lib/assets/images/unandesLogo.png',
        width: _size.width * 0.5,
      ),
    );
  }

  // MÉtodo para imagenes
  Widget _imageBuldingApp() {
    final _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        top: _size.height * 0.015,
        bottom: _size.height * 0.015,
      ),
      child: Image.asset('lib/assets/images/realEstate.png',
          width: 130, height: 130),
    );
  }
// Texto de Información

  Widget _textInformacion() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 40, right: 40, left: 40),
      child: Text(
          'Esta opción permite añadir una nueva categoria de servios inmobiliarios como por ejemplo: Alquiler, Anticrético, Venta.',
          style: TextStyle(
            fontSize: 17,
            color: Colors.grey,
          ),
          textAlign: TextAlign.justify),
    );
  }

  //Método de campo de Nombre de nueva categoría
  Widget _textFieldNombreCategoria() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.nombreCategoriaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Ingresar nombre de la categoría',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.list_alt_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de nombre de categoría
  Widget _textFieldDescripcionCategoria() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.descripcionCategoriaController,
        maxLength: 255,
        maxLines: 4,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Ingresar descripción de categoria',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.description_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método para el ElevateButton de registró de nueva categoría
  Widget _crearNuevaCategoriaBoton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.all(50),
      child: ElevatedButton(
        onPressed: _controlador.crearCategoria,
        child: Text('Registrar nueva cateoría'),
        style: ElevatedButton.styleFrom(
            primary: ColorsTheme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
