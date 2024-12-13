import 'package:bienes_raices_app/src/vistas/modificar_usuario/cliente_modificar_usuario_controlador.dart';
import 'package:flutter/material.dart';
import 'package:bienes_raices_app/imports/imports.dart';
import 'package:flutter/scheduler.dart';

class ClienteModificarUsuarioPage extends StatefulWidget {
  const ClienteModificarUsuarioPage({Key key}) : super(key: key);

  @override
  State<ClienteModificarUsuarioPage> createState() =>
      _ClienteModificarUsuarioPageState();
}

class _ClienteModificarUsuarioPageState
    extends State<ClienteModificarUsuarioPage> {
  //Llamamos al controlador
  ClienteModificarUsuarioControlador _controlador =
      new ClienteModificarUsuarioControlador();

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
                _tituloFormularioRegistro(),
                const SizedBox(
                  height: 30,
                ),
                Center(child: _userImageContainer()),
                const SizedBox(
                  height: 30,
                ),
                _textFielNombre(),
                const SizedBox(
                  height: 17,
                ),
                _textFielApellidos(),
                const SizedBox(
                  height: 17,
                ),
                _textFielCelular(),
                const SizedBox(
                  height: 30,
                ),
                _editarPerfilBoton(),
                const SizedBox(
                  height: 60,
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
          radius: 100,
          backgroundImage: _controlador.imageFile != null
              ? FileImage(_controlador.imageFile)
              : _controlador.user?.image != null
                  ? NetworkImage(_controlador.user.image)
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
              'Editar Perfil de ',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.normal,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
          Container(
            child: Text(
              'Usuario',
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

  //Método para el ElevateButton de Inicio Registrar Usuario
  Widget _editarPerfilBoton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: _controlador.isEnable ? _controlador.update : null,
        child: Text(
          'Actualizar Perfil',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
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
