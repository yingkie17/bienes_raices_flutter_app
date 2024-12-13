import 'package:flutter/material.dart';
import 'package:bienes_raices_app/imports/imports.dart';
import 'package:flutter/scheduler.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({Key key}) : super(key: key);

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  //Llamamos al controlador
  RegistroControlador _controlador = new RegistroControlador();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //Al controlador lo inicializamos
      _controlador.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(top: 10, left: 10, child: _backArrow()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _logoContainer(),
                Center(child: _userImageContainer()),
                const SizedBox(
                  height: 30,
                ),
                _tituloFormularioRegistro(),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      _textFielNombre(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFielApellidos(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFielCorreoElectronico(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFielCelular(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFieldContrasena(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFieldValidarContrasena(),
                      const SizedBox(
                        height: 30,
                      ),
                      _registrarUsuarioBoton(),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

// Metodo  Flecha Atrás
  Widget _backArrow() {
    return IconButton(
        onPressed: _controlador.backpage,
        icon: Icon(
          Icons.arrow_back,
          color: ColorsTheme.primaryColor,
        ));
  }

// Méetodo Logo contenedor
  Widget _logoContainer() {
    final _size = MediaQuery.of(context).size;
    return Container(
      child: Image.asset(
        'lib/assets/images/logoMyAgentBlue.png',
        width: _size.width * 0.5,
      ),
    );
  }

  //Método de Imagen Icono Usuario

  Widget _userImageContainer() {
    final _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        top: _size.height * 0.02,
      ),
      child: GestureDetector(
        onTap: _controlador.showAlertDialog,
        child: CircleAvatar(
          radius: 70,
          backgroundImage: _controlador.imageFile != null
              ? FileImage(_controlador.imageFile)
              : AssetImage(
                  'lib/assets/images/user_profile.png',
                ),
        ),
      ),
    );
  }

//método de Título de Fomrulario
  Widget _tituloFormularioRegistro() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              'Formulario de Registro de ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
          Container(
            child: Text(
              'Nuevo Usuario',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Método de Campo de Nombre
  Widget _textFielNombre() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.nombreController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Ingresar Nombre ',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.person,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de Campo Apellidos
  Widget _textFielApellidos() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.apellidosController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Ingresar Apellidos',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.person_outline,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método para el TextField de Correo Electrónico
  Widget _textFielCorreoElectronico() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.correoController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Ingresar Correo Electrónico ',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.email,
            color: ColorsTheme.primaryColor,
          ),
        ),
        validator: (value) {
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

          RegExp regExp = new RegExp(pattern);

          return regExp.hasMatch(value ?? '')
              ? null
              : 'Correo electrónico no válido';
        },
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  //Método de Campo Celular
  Widget _textFielCelular() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.telefonoController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Ingresar Teléfono',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.phone,
            color: ColorsTheme.primaryColor,
          ),
        ),
        keyboardType: TextInputType.phone,
      ),
    );
  }

//Método para el TextField de Contraseña
  Widget _textFieldContrasena() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.contrasenaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Ingresar Contraseña',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.lock,
            color: ColorsTheme.primaryColor,
          ),
        ),
        obscureText: true,
      ),
    );
  }

  //Método para el TextField de válidar Contraseña
  Widget _textFieldValidarContrasena() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.validarContrasenaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Valide Su Contraseña',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: ColorsTheme.primaryColor,
          ),
        ),
        obscureText: true,
      ),
    );
  }

  //Método para el ElevateButton de Inicio Registrar Usuario
  Widget _registrarUsuarioBoton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: _controlador.registrar,
        child: Text('Registrar Usuario'),
        style: ElevatedButton.styleFrom(
            primary: ColorsTheme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  //Método de Submit
  //Método Refresh
  void refresh() {
    setState(() {});
  }
}
