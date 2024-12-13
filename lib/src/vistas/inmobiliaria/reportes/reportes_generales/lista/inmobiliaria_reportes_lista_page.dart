import 'dart:ui';

import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/assets/widgets/no_data_widgets.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/reportes_moldel.dart';
import 'package:bienes_raices_app/src/modelos/rol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'inmobiliaria_reportes_lista_controlador.dart';

class InmobiliariaReportesListaPage extends StatefulWidget {
  const InmobiliariaReportesListaPage({Key key}) : super(key: key);

  @override
  State<InmobiliariaReportesListaPage> createState() =>
      _InmobiliariaReportesListaPageState();
}

class _InmobiliariaReportesListaPageState
    extends State<InmobiliariaReportesListaPage> {
  InmobiliariaReportesListaController _controlador =
      new InmobiliariaReportesListaController();

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
    return DefaultTabController(
      length: _controlador.reports?.length,
      child: Scaffold(
        key: _controlador.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.white10,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.blueGrey,
              ),
              onPressed: () {
                Navigator.pop(
                    context); // Esto hará que la aplicación vaya hacia atrás
              },
            ),
            centerTitle: true,
            title: Text(
              'Todos los Reportes',
              style: TextStyle(color: Colors.blueGrey),
            ),
            bottom: TabBar(
              indicatorColor: Colors.blueGrey,
              labelColor: Colors.blueGrey,
              unselectedLabelColor: Colors.grey[800],
              isScrollable: true,
              tabs: List<Widget>.generate(_controlador.reports.length, (index) {
                return Tab(
                  child: Text(
                    _controlador.reports[index].nameReport ?? '',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }),
            ),
          ),
        ),
        drawer: _menuDrawer(),
        body: _controlador.reports.isEmpty
            ? null
            : TabBarView(
                children: _controlador.reports.map((Reports reports) {
                return FutureBuilder<List<ReportsHasReports>>(
                  future: _controlador.getReports(reports.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data.isEmpty) {
                      return Container(
                        margin: EdgeInsets.only(top: 30),
                        child: NoDataWidets(
                          text: 'No se obtuvo más resultados de la búsqueda',
                        ),
                      );
                    }

                    // Aquí puedes usar snapshot.data
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 0.99,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final report = snapshot.data[index];
                        return _tarjetaReportes(report);
                      },
                    );
                  },
                );
              }).toList()),
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

          //Lista de Propiedades
          ListTile(
            onTap: _controlador.goToOrdesList,
            title: Text('Mis Tickets'),
            trailing: Icon(
              CupertinoIcons.tickets,
              color: ColorsTheme.primaryColor,
            ),
          ),
          //Lista de Roles Usuario
          //Se valida si el usuario tiene mas de un rol asignado
          _controlador.user != null
              ? _controlador.user.roles.length > 1
                  ? ListTile(
                      onTap: _controlador.goToRoles,
                      title: Text('Panel de Administrador:'),
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

//Método para tener la lista de roles de usuario en el ménu
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

  //En esta Seccion se va trabajar la parte de layout

//Tarjetas de reportes
  Widget _tarjetaReportes(ReportsHasReports reportsHasReports) {
    return GestureDetector(
      onTap: () {
        _controlador.goToReportDetail(reportsHasReports);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Alinea los elementos a los extremos
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 20), // Margen solo a la izquierda
                        child: Text(
                          'Reporte: ${reportsHasReports.id}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            right: 20), // Margen solo a la derecha
                        child: Text(
                          ' Fecha: ${_controlador.formatFechaCreacionReporte(reportsHasReports?.dateReport ?? '')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha creación reporte: ${_controlador.formatFechaCreacionReporte(reportsHasReports?.dateReport ?? '')}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                      ),
                      Text(
                        'Cliente: ${reportsHasReports.idUser ?? 'No asignado'}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                      ),
                      Text(
                        'Agente: ${reportsHasReports.idAgent ?? 'No asignado'}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                      ),
                      Text(
                        'Producto: ${reportsHasReports.idProduct ?? 'No asignado'}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                      ),
                      Text(
                        'Estado del reporte: ${reportsHasReports.statusReport ?? 'No asignado'}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                      ),
                      Text(
                        'Título de Reporte: ${reportsHasReports.nameReport ?? ''}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                      ),
                      Text(
                        'Descripción reporte: ${reportsHasReports.descriptionReport ?? 'No asignado'}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Método para el campo para búsqueda
  Widget _buscadorAppbar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        onChanged: _controlador.onChangedText,
        decoration: InputDecoration(
          hintText: 'Buscar',
          hintStyle: TextStyle(fontSize: 17, color: Colors.grey[400]),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.grey[500],
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[300],
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[500],
              )),
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
