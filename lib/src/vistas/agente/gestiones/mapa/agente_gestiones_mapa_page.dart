import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'agente_gestiones_mapa_controlador.dart';

class AgenteGestionesMapaPage extends StatefulWidget {
  const AgenteGestionesMapaPage({Key key}) : super(key: key);

  @override
  State<AgenteGestionesMapaPage> createState() =>
      _AgenteGestionesMapaPageState();
}

class _AgenteGestionesMapaPageState extends State<AgenteGestionesMapaPage> {
  AgenteGestionesMapaController _controlador =
      new AgenteGestionesMapaController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controlador.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controlador.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: _googlemaps()),
          Container(
            alignment: Alignment.bottomCenter,
            child: _buttonSelecionarPunto(),
          ),
          SafeArea(
            child: Column(
              children: [
                _buttonCentrarPosicion(),
                Spacer(),
                _tajertaOrdenInformacion()
              ],
            ),
          ),
          Positioned(top: 40, left: 15, child: _iconGoogleMaps()),
        ],
      ),
    );
  }

  Widget _tajertaOrdenInformacion() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height * 0.50,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3))
            ]),
        child: Column(
          children: [
            _listTileDireccion('Zona: ',
                _controlador.order?.address?.neighborhood, Icons.my_location),
            _listTileDireccion('Dirección: ',
                _controlador.order?.address?.address, Icons.location_on),
            Divider(
              color: Colors.grey[900],
              endIndent: 30,
              indent: 30,
            ),
            _informacionCliente(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [_atenderButton(), _cancelarButton()],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _informacionCliente() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              'Informacion de Cliente',
              style: TextStyle(
                  fontFamily: 'NimbusSans',
                  fontSize: 14,
                  color: ColorsTheme.primaryDarkColor),
            ),
          ),
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                child: FadeInImage(
                  fit: BoxFit.contain,
                  image: _controlador.order?.client?.image != null
                      ? NetworkImage(_controlador?.order?.client.image)
                      : AssetImage('lib/assets/images/user_profile.png'),
                  fadeInDuration: Duration(milliseconds: 30),
                  placeholder: AssetImage('lib/assets/images/no-image.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                child: Column(
                  children: [
                    Text(
                      '${_controlador.order?.client?.name ?? ''}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    ),
                    Text(
                      '${_controlador.order?.client?.lastname ?? ''}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.blue),
                child: IconButton(
                  onPressed: _controlador.llamarCliente,
                  icon: Icon(Icons.phone, color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _listTileDireccion(String title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
              fontSize: 14,
              color: ColorsTheme.primaryColor),
        ),
        subtitle: Text(
          subtitle ?? 'No se obtuvo información',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
              fontSize: 13,
              color: Colors.grey[600]),
          maxLines: 3,
        ),
        trailing: Icon(iconData),
      ),
    );
  }

  Widget _googlemaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _controlador.initialPosition,
      onMapCreated: _controlador.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(_controlador.markers.values),
      polylines: _controlador.polylines,
    );
  }

  Widget _buttonCentrarPosicion() {
    return GestureDetector(
        onTap: () {},
        child: Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Card(
            shape: CircleBorder(),
            color: Colors.white,
            elevation: 8,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.location_searching,
                color: Colors.grey[700],
                size: 25,
              ),
            ),
          ),
        ));
  }

  Widget _buttonSelecionarPunto() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 70, vertical: 40),
      child: ElevatedButton(
        onPressed: _controlador.selectPuntoReferencia,
        child: Text(' Seleccionar Dirección'),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            primary: ColorsTheme.primaryColor),
      ),
    );
  }

  //Icono GoogleMaps
  Widget _iconGoogleMaps() {
    return GestureDetector(
      onTap: _controlador.launchGoogleMaps,
      child: Container(
        child: Image.asset('lib/assets/images/googlemaps.png'),
        height: 35,
        width: 35,
      ),
    );
  }

  //Icono Waze
  Widget _iconWaze() {
    return GestureDetector(
      onTap: _controlador.launchWaze,
      child: Container(
        child: Image.asset('lib/assets/images/waze.png'),
        height: 35,
        width: 35,
      ),
    );
  }

  //Botón Realizar Consulta de Propiedades
  //Botón Realizar Consulta de Propiedades

  Widget _atenderButton() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.41,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text('Confirmación'),
                      content: Text('¿Deseas concretar el negocio?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: _controlador.updateToConcretado,
                          child: Text('Aceptar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        )
                      ]);
                });
          },
          style: ElevatedButton.styleFrom(
              elevation: 8,
              primary: ColorsTheme.secondaryColor,
              padding: EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Concretar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 3,
                    right: 10,
                  ),
                  height: 30,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ));
  }

//Botón Realizar Consulta de Propiedades

  Widget _cancelarButton() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.41,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text('Confirmación'),
                      content: Text(
                          '¿Deseas continuar con la cancelación de la negociación?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: _controlador.updateOrderCancel,
                          child: Text('Aceptar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        )
                      ]);
                });
          },
          style: ElevatedButton.styleFrom(
              elevation: 8,
              primary: Colors.redAccent,
              padding: EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Descartar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 3,
                    right: 10,
                  ),
                  height: 30,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void refresh() {
    if (!mounted) return;
    setState(() {});
  }
}
