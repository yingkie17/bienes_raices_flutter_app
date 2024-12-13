import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cliente_direcciones_mapa_controlador.dart';

class ClienteDireccionesMapaPage extends StatefulWidget {
  const ClienteDireccionesMapaPage({Key key}) : super(key: key);

  @override
  State<ClienteDireccionesMapaPage> createState() =>
      _ClienteDireccionesMapaPageState();
}

class _ClienteDireccionesMapaPageState
    extends State<ClienteDireccionesMapaPage> {
  ClienteDireccionesMapaController _controlador =
      new ClienteDireccionesMapaController();

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
        title: Text('Marca tu ubicación en el mapa'),
      ),
      body: Stack(
        children: [
          _googlemaps(),
          Container(
            alignment: Alignment.center,
            child: _iconoMiLocacion(),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.topCenter,
            child: _tarjetaDireccion(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: _buttonSelecionarPunto(),
          )
        ],
      ),
    );
  }

  Widget _tarjetaDireccion() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: ColorsTheme.lightColor,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            _controlador.addressName ?? '',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _iconoMiLocacion() {
    return Image.asset(
      'lib/assets/images/my_location.png',
      width: 50,
      height: 50,
    );
  }

  Widget _googlemaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _controlador.initialPosition,
      onMapCreated: _controlador.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        _controlador.initialPosition = position;
      },
      onCameraIdle: () async {
        await _controlador.setLocationDraggableInfo();
      },
    );
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
            primary: ColorsTheme.secondaryColor),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
