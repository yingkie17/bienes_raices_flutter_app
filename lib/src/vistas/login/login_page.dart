import 'package:bienes_raices_app/imports/imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//Llamamos al controlador
  LoginControlador _controlador = new LoginControlador();

//vamos a ejecutar el metodo init del controlador para inicializar en page el controlador dentro del init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Init State');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      print('Scheduler Binfing');
      _controlador.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Metodo Build');
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _logoContainer(),
              SizedBox(
                height: 30,
              ),
              _imageLoginApp(),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        //Campo de Texto Correo Electrónico
                        _textFielCorreoElectronico(),
                        SizedBox(
                          height: 20,
                        ),
                        //Campo dE TextO Contraseña
                        _textFieldContrasena(),
                        SizedBox(
                          height: 20,
                        ),
                        //Boton de Inicio de Sesion
                        _elevateButtonIncioSesion(),
                        SizedBox(
                          height: 20,
                        ),
                        // Registrar Cuenta
                        _registrarCuenta(),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

//Metodo LogoContainer

  Widget _logoContainer() {
    final _size = MediaQuery.of(context).size;
    return Container(
      child: Image.asset(
        'lib/assets/images/logoMyAgentBlue.png',
        width: _size.width * 0.5,
      ),
    );
  }

// MÉtodo para imagenes
  Widget _imageLoginApp() {
    final _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        top: _size.height * 0.02,
      ),
      child: Image.asset('lib/assets/images/realEstate.png',
          width: 230, height: 230),
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
        //Pasamos el contenido del texto al Controlador
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

//Método para el TextField de Contraseña
  Widget _textFieldContrasena() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        //Pasamos el contenido del texto al Controlador
        controller: _controlador.contrasenaController,
        obscureText: true,
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
      ),
    );
  }

//Método para el ElevateButton de Inicio de Sesión

  Widget _elevateButtonIncioSesion() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: _controlador.login,
        child: Text(
          'Iniciar sesión',
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
            primary: ColorsTheme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

//Método de Registro de Cuenta

  Widget _registrarCuenta() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes una cuenta?',
          style: TextStyle(color: ColorsTheme.primaryColor, fontSize: 17),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () => _controlador.goToRegistroPage(),
          child: Text(
            'Registrarse',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorsTheme.primaryColor,
                fontSize: 17),
          ),
        )
      ],
    );
  }
}
