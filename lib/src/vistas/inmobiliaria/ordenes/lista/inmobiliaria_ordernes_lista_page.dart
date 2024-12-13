import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/assets/timeStamp/relative_time_util.dart';
import 'package:bienes_raices_app/assets/widgets/no_data_widgets.dart';
import 'package:bienes_raices_app/src/modelos/order_model.dart';
import 'package:bienes_raices_app/src/modelos/rol.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/ordenes/lista/inmobiliaria_ordenes_lista_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class InmobiliariaOrdernesListPage extends StatefulWidget {
  Order order;
  InmobiliariaOrdernesListPage({Key key, @required this.order})
      : super(key: key);

  @override
  State<InmobiliariaOrdernesListPage> createState() =>
      _InmobiliariaOrdernesListPageState();
}

class _InmobiliariaOrdernesListPageState
    extends State<InmobiliariaOrdernesListPage> {
  InmobiliariaOrderneslistController _controlador =
      new InmobiliariaOrderneslistController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
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
      length: _controlador.status?.length,
      child: Scaffold(
        key: _controlador.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorsTheme.primaryColor,
              ),
              onPressed: () {
                Navigator.pop(
                    context); // Esto hará que la aplicación vaya hacia atrás
              },
            ),
            centerTitle: true,
            title: Text(
              'Órdenes',
              style: TextStyle(color: ColorsTheme.secondaryColor),
            ),
            bottom: TabBar(
              indicatorColor: ColorsTheme.primaryColor,
              labelColor: ColorsTheme.lightColor,
              unselectedLabelColor: Colors.grey[700],
              isScrollable: true,
              tabs: List<Widget>.generate(_controlador.status.length, (index) {
                return Tab(
                  child: Text(
                    _controlador.status[index] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        drawer: _menuDrawer(),
        body: _controlador.status.isEmpty
            ? null
            : TabBarView(
                children: _controlador.status.map((String status) {
                return FutureBuilder(
                    future: _controlador.getOrders(status),
                    builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3, vertical: 5),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _tarjetaOrdenes(snapshot.data[index]);
                            },
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(top: 30),
                            child: NoDataWidets(
                                text:
                                    'No se obtuvo más resultados de la búsqueda'),
                          );
                        }
                      } else {
                        return Container(
                          margin: EdgeInsets.only(top: 30),
                          child: NoDataWidets(
                            text: 'No Existe Resgistró status',
                          ),
                        );
                      }
                    });
              }).toList()),
      ),
    );
  }

  Widget _tarjetaOrdenes(Order order) {
    return GestureDetector(
      onTap: () {
        _controlador.openBottomSheet(order);
      },
      child: Container(
        height: 210,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                      color: ColorsTheme.primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Orden: ${order.id}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'NimbusSans'),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60, left: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      child: Text(
                        'Fecha Creacion Orden: ${RelativeTimeUtil.getRelativeTime(order?.timestamp ?? 0)}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      child: Text(
                        'Cliente: ${order.client?.name ?? ''} ${order.client?.lastname ?? ''}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      child: Text(
                        'Dirección: ${order.address.address ?? ''}',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                        maxLines: 3,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      child: Text(
                        DateFormat('HH:mm').format(DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          order.address.timeEvent.hour,
                          order.address.timeEvent.minute,
                        )),
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      child: Text(
                        DateFormat('dd-MM-yyyy')
                                .format(order.address?.dateEvent) ??
                            '',
                        style:
                            TextStyle(fontSize: 14, fontFamily: 'NimbusSans'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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
                Container(
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
                      placeholder: AssetImage('lib/assets/images/no-image.png'),
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

          //Nueva Categoria de Servicios
          ListTile(
            onTap: _controlador.goToCrearCategorias,
            title: Text('Crear nueva categoria de Propiedades'),
            trailing: Icon(
              Icons.category,
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
          ListTile(
            onTap: _controlador.goToPanel,
            title: Text('Panel de Administrador:'),
            trailing: Icon(
              Icons.account_tree_sharp,
              color: ColorsTheme.primaryColor,
            ),
          ),
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

  void refresh() {
    setState(() {});
  }
}
