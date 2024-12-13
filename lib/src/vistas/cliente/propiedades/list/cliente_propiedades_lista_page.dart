import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/assets/widgets/no_data_widgets.dart';
import 'package:bienes_raices_app/src/modelos/categoria_model.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/rol.dart';
import 'package:bienes_raices_app/src/vistas/cliente/propiedades/list/cliente_propiedades_lista_controlador.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientePropiedadesList extends StatefulWidget {
  const ClientePropiedadesList({Key key}) : super(key: key);

  @override
  State<ClientePropiedadesList> createState() => _ClientePropiedadesListState();
}

class _ClientePropiedadesListState extends State<ClientePropiedadesList> {
  ClientePropiedadesListController _controlador =
      new ClientePropiedadesListController();

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
      length: _controlador.categories?.length,
      child: Scaffold(
        key: _controlador.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(180),
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: _iconMenuDrawer(),
            actions: [
              _bolsaPropiedades(),
            ],
            flexibleSpace: Column(
              children: [SizedBox(height: 105), _buscadorAppbar()],
            ),
            bottom: TabBar(
              indicatorColor: ColorsTheme.primaryColor,
              labelColor: Colors.grey,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_controlador.categories.length,
                  (index) {
                return Tab(
                  child: Text(
                    _controlador.categories[index].name ?? '',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }),
            ),
          ),
        ),
        drawer: _menuDrawer(),
        body: _controlador.categories.isEmpty
            ? null
            : TabBarView(
                children: _controlador.categories.map((Category category) {
                return FutureBuilder(
                    future: _controlador.getProducts(
                        category.id, _controlador.nombrePropiedad),
                    builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3, vertical: 5),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 0.7),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _tarjetaProducto(snapshot.data[index]);
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
                            text: 'No Existe Resgistró de Propiedades',
                          ),
                        );
                      }
                    });
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

//Tarjetas de las propiedades

//Método para mostrar productos en las tarjetas

  Widget _tarjetaProducto(Product product) {
    return GestureDetector(
      onTap: () {
        _controlador.openBottomSheet(product);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        height: 350,
        child: Card(
            //color: ColorsTheme.primaryOpacityColor,
            elevation: 8.1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 130,
                      margin: EdgeInsets.only(top: 0),
                      width: MediaQuery.of(context).size.width * 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: FadeInImage(
                          image: product.imageProduct1 != null
                              ? NetworkImage(product.imageProduct1)
                              : AssetImage('lib/assets/images/no-image.png'),
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 50),
                          placeholder:
                              AssetImage('lib/assets/images/no-image.png'),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 5),
                      height: 33,
                      child: Text(
                        product.cityProduct ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NimbusSans',
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 0, left: 10, right: 10, bottom: 5),
                      child: Text(
                        product.nameProduct ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'NimbusSans',
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: ColorsTheme.primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${product.priceProduct ?? 0.0} \$',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NimbusSans',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

//Método para icono de bolsa de propiedades
  Widget _bolsaPropiedades() {
    return GestureDetector(
      onTap: _controlador.goToOrderCreatePage,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 25, top: 15),
            child: Icon(
              CupertinoIcons.shopping_cart,
              color: ColorsTheme.primaryColor,
            ),
          ),
          Positioned(
              top: 15,
              right: 12,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ))
        ],
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
