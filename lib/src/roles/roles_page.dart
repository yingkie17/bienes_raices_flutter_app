import 'package:bienes_raices_app/src/modelos/rol.dart';
import 'package:bienes_raices_app/src/roles/roles_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key key}) : super(key: key);

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  RolesControlador _controlador = new RolesControlador();

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
        title: Text('Menu de Opciones'),
        actions: [
          IconButton(
              onPressed: _controlador.logout, icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: Container(
        margin:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.044),
        child: ListView(
            children: _controlador.user != null
                ? _controlador.user.roles.map((Rol rol) {
                    return _tarjetaRol(rol);
                  }).toList()
                : []),
      ),
    );
  }

  Widget _tarjetaRol(Rol rol) {
    return GestureDetector(
      onTap: () {
        _controlador.goToPage(rol.route);
      },
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 130,
            child: FadeInImage(
              image: rol.image != null
                  ? NetworkImage(rol.image)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 40),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
          ),
          SizedBox(height: 5),
          Text(
            rol.name ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
