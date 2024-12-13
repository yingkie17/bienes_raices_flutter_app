import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/src/vistas/agente/gestiones/menu/agente_gestiones_menu_controlador.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/gestiones/list/inmobiliaria_gestiones_list_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:bienes_raices_app/src/modelos/rol.dart';

class AgenteGestionesMenuPage extends StatefulWidget {
  const AgenteGestionesMenuPage({Key key}) : super(key: key);

  @override
  State<AgenteGestionesMenuPage> createState() =>
      _AgenteGestionesMenuPageState();
}

class _AgenteGestionesMenuPageState extends State<AgenteGestionesMenuPage> {
  AgenteGestionesMenuController _controlador =
      new AgenteGestionesMenuController();

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
      key: _controlador.key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Panel de Agente',
          style: TextStyle(color: ColorsTheme.lightColor),
        ),
        leading: _iconMenuDrawer(),
      ),
      drawer: _menuDrawer(),
      body: GridView.count(
        crossAxisCount: 2, // dos columnas
        children: [
          GestureDetector(
              onTap: _controlador.goToEstadoOrdenes,
              child: buildMenuItem(
                  context, Icons.assignment, 'Estado de órdenes')),
          GestureDetector(
              onTap: _controlador.goToReportes,
              child: buildMenuItem(context, Icons.report, 'Generar reporte')),
          GestureDetector(
              onTap: _controlador.goToListaReportes,
              child: buildMenuItem(
                  context, Icons.list_rounded, 'Reportes Generados')),
          GestureDetector(
              onTap: _controlador.goToCrearProductos,
              child:
                  buildMenuItem(context, Icons.home, 'Crear nueva propiedad')),
        ],
      ),
    );
  }

  Widget _iconMenuDrawer() {
    return IconButton(
        alignment: Alignment.topLeft,
        onPressed: _controlador.openDrawer,
        icon: Icon(
          Icons.menu_open_rounded,
          color: ColorsTheme.primaryColor,
        ));
  }

  Widget _menuDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorsTheme.secondaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Foto de Usuario
                GestureDetector(
                  onTap: _controlador.goToModificarUsuario,
                  child: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 10, left: 20),
                    height: 60,
                    width: 60,
                    child: ClipOval(
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        image: _controlador.user?.image != null
                            ? NetworkImage(_controlador.user?.image)
                            : AssetImage('lib/assets/images/user_profile.png'),
                        fadeInDuration: Duration(milliseconds: 30),
                        placeholder:
                            AssetImage('lib/assets/images/no-image.png'),
                      ),
                    ),
                  ),
                ),
                //Información de Usuario
                //Nombre Usuario
                Text(
                  '${_controlador.user?.name ?? ''} ${_controlador.user?.lastname ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 2,
                ),
                //Correo Electrónico Usuario
                Text(
                  _controlador.user?.email ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  _controlador.user?.phone ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          //Editar Perfil
          ListTile(
            onTap: _controlador.goToModificarUsuario,
            title: Text('Editar Perfil'),
            trailing: Icon(
              Icons.edit_outlined,
              color: ColorsTheme.primaryColor,
            ),
          ),

          //Agregar nuevos productos
          ListTile(
            onTap: _controlador.goToCrearProductos,
            title: Text('Crear nuevo Propiedad'),
            trailing: Icon(
              Icons.home,
              color: ColorsTheme.primaryColor,
            ),
          ),

          //Lista de Roles Usuario
          //Se valida si el usuario tiene mas de un rol asignado
          _controlador.user != null
              ? _controlador.user.roles.length > 1
                  ? ListTile(
                      onTap: _controlador.goToRoles,
                      title: Text('Panel de Roles de Usuario:'),
                      trailing: Icon(
                        Icons.account_tree_sharp,
                        color: ColorsTheme.primaryColor,
                      ),
                    )
                  : Container()
              : Container(),
          _controlador.user != null
              ? _controlador.user.roles.length > 1
                  ? Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _controlador.user != null
                            ? _controlador.user.roles.map((Rol rol) {
                                return _listandoRolesUsuario(rol);
                              }).toList()
                            : [],
                      ),
                    )
                  : Container()
              : Container(),

          //End of Lista de Roles Usuario
          //Cerrar Sesión
          ListTile(
            onTap: _controlador.logout,
            title: Text('Cerrar Sesión',
                style: TextStyle(
                  color: Colors.redAccent,
                )),
            leading: Icon(
              Icons.power_settings_new_rounded,
              color: ColorsTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listandoRolesUsuario(Rol rol) {
    return GestureDetector(
      onTap: () {
        _controlador.goToPage(rol.route);
      },
      child: ListTile(
        trailing: FadeInImage(
          height: 30,
          image: rol.image != null
              ? NetworkImage(rol.image)
              : AssetImage('lib/assets/images/no-image.jpg'),
          fit: BoxFit.contain,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('lib/assets/images/jar-loading.gif'),
        ),
        title: Text(
          rol.name ?? 'No se pudo encontrar el rol de usuario',
          style: TextStyle(
            fontSize: 13,
            color: ColorsTheme.primaryDarkColor,
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, String title) {
    return Container(
      margin: EdgeInsets.all(16.0), // margen
      padding: EdgeInsets.all(16.0), // padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // sombra
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50.0,
            color: Colors.blue,
          ),
          SizedBox(height: 16.0),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
