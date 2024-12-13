import 'package:bienes_raices_app/src/vistas/inmobiliaria/agentes/registrar_nuevo_agente_controlador.dart';
import 'package:flutter/material.dart';
import 'package:bienes_raices_app/imports/imports.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';

class InmobiliariaRegristrarNuevoAgentePage extends StatefulWidget {
  const InmobiliariaRegristrarNuevoAgentePage({Key key}) : super(key: key);

  @override
  State<InmobiliariaRegristrarNuevoAgentePage> createState() =>
      _InmobiliariaRegristrarNuevoAgentePageState();
}

class _InmobiliariaRegristrarNuevoAgentePageState
    extends State<InmobiliariaRegristrarNuevoAgentePage> {
  //Llamamos al controlador
  InmobiliariaRegristrarNuevoAgenteControlador _controlador =
      new InmobiliariaRegristrarNuevoAgenteControlador();

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
                context); // Esto hará que la aplicación vaya hacia atrás
          },
        ),
        centerTitle: true,
        title: Text(
          'Registrar nuevo agente',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      _textFielcarnetIdentidad(),
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
                      _textFielDireccion(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFielFechaNacimiento(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFielLugarNacimiento(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFielExperiencia(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFieldCertificados(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFieldFormacionProfesional(),
                      const SizedBox(
                        height: 17,
                      ),
                      _textFieldFechaInicioTrabajo(),
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
                )
              ],
            )
          ],
        ),
      )),
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
              'Registrar ',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
          Container(
            child: Text(
              'Agente Inmobiliario',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
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
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.nombreController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Nombre ',
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
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.apellidosController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Apellidos',
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

  //Método de Campo de Carnet Identidad
  Widget _textFielcarnetIdentidad() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.carnetIdentidadController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Carnet de Identidad ',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.perm_identity,
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
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.correoController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Correo Electrónico ',
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
              : 'El correcto electrónico no es válido';
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
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.telefonoController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Teléfono',
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

  //Método de Campo de Dirección
  Widget _textFielDireccion() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.direccionController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Dirección ',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.location_city,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de Campo de  Fecha de Nacimiento
  Widget _textFielFechaNacimiento() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          _selectDate(context, 'fechaNacimiento');
        },
        child: IgnorePointer(
          child: TextFormField(
            controller: _controlador.fechaNacimientoController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.blueGrey),
              hintText: 'Fecha Nacimiento',
              fillColor: ColorsTheme.primaryDarkColor,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.date_range,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Método de Campo de Lugar de Nacimiento
  Widget _textFielLugarNacimiento() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.lugarNacimientoController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Lugar Nacimiento ',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.place,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

//Método para el TextField de Contraseña
  Widget _textFieldContrasena() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.contrasenaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
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
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.validarContrasenaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
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

  //Método de Campo de Experiencia
  Widget _textFielExperiencia() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.experienciaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Experiencia Laboral ',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.timelapse,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de Campo de Certificados
  Widget _textFieldCertificados() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.certificacionesController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Certificaciones ',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.grade,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de Campo de Formación Profesional
  Widget _textFieldFormacionProfesional() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.formacionProfesionalController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.blueGrey),
          hintText: 'Fomración Profesional ',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.folder_special_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de Campo de Fecha de Inicio de Trabajo
  Widget _textFieldFechaInicioTrabajo() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          _selectDate(context, 'fechaInicioTrabajo');
        },
        child: IgnorePointer(
          child: TextFormField(
            controller: _controlador.fechaIncioTrabajoController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.blueGrey),
              hintText: 'Fecha Inicio Trabajo',
              fillColor: ColorsTheme.primaryDarkColor,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.date_range,
                color: ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String field) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (field == 'fechaNacimiento') {
          _controlador.fechaNacimientoController.text =
              DateFormat('dd-MM-yyyy').format(picked);
        } else if (field == 'fechaInicioTrabajo') {
          _controlador.fechaIncioTrabajoController.text =
              DateFormat('dd-MM-yyyy').format(picked);
        }
      });
    }
  }

  //Método Refresh
  void refresh() {
    setState(() {});
  }
}
