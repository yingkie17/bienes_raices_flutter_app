import 'dart:async';
import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/id_reports/id_reports.dart';
import 'package:bienes_raices_app/snackbar/snackbar.dart';
import 'package:bienes_raices_app/src/api/entorno.dart';
import 'package:bienes_raices_app/src/modelos/order_model.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/response_api.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/orders_provider.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClienteOrdenesMapaController {
  BuildContext context;
  Function refresh;
  Position _position;
  String addressName;
  LatLng addressLatLng;

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-16.518938, -68.114489),
    zoom: 17,
  );

  Completer<GoogleMapController> _mapController = Completer();
  BitmapDescriptor agentMarker;
  BitmapDescriptor puntoEncuentroMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Order order;
  Set<Polyline> polylines = {};
  List<LatLng> points = [];
  OrdersProvider _ordersProvider = new OrdersProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();
  double _distanceBetween;
  IO.Socket socket;
  ReporteProvider _reporteProvider = new ReporteProvider();
  ReportsHasReports reportsHasReports;
  Idreports _idreports = new Idreports();
  String idUserAgente;
  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    order = Order.fromJson(
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>);
    agentMarker =
        await createMarkerFromAssets('lib/assets/images/agentMap.png');
    puntoEncuentroMarker =
        await createMarkerFromAssets('lib/assets/images/inmobiliariaMap.png');

    ///Socket
    // socket = IO.io('http://${Entorno.baseUrl}/orders/delivery', <String, dynamic>{'transports': ['websocket'],'autoConnect': false,});
    socket = IO.io(
        'http://${Entorno.API_BIENESRAICES}/orders/delivery', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket = socket.connect();
    socket.on('position/${order.id}', (data) {
      print('Data Emitida: ${data}');
      addMarker('Agente Inmobiliario', data['lat'], data['lng'],
          'Posición del Agente', '', agentMarker);
    });

    user = User.fromJson(await _sharedPref.read('user'));
    _ordersProvider.init(context, user);
    _progressDialog = new ProgressDialog(context: context);
    _reporteProvider.init(context, user);
    checkGPS();
    idUserAgente = user.id;
    refresh();
  }

  void emitPosition() {
    socket.emit('Position', {
      'id_order': order.id,
      'lat': _position.latitude,
      'lng': _position.longitude,
    });
    refresh();
  }

  void updateOrderCancel() async {
    ResponseApi responseApi =
        await _ordersProvider.updateTicketToCancelado(order);
    if (responseApi.success) {
      // Generar un reporte al cancelar la orden
      ReportsHasReports reportsHasReports = new ReportsHasReports(
        idReports:
            '${_idreports.idReportCancel.toString()}', // ID del tipo de reporte para las órdenes canceladas
        idUser: '${user.id}',
        idAgent: null,
        nameReport:
            'Orden Cancelada (Cliente) ${order.client.name} ${order.client.lastname},\n Id Orden: ${order.id},\n',
        descriptionReport:
            'La orden no tiene asignado un agente inmobiliario, Se ha cancelado la orden con ID: ${order.id},La orden fue cancelada por el Cliente: ${order.client.name}, ${order.client.lastname},\n\n=== Datos de Cliente ===\n \n Nombre: ${order.client.name},\n Apellidos: ${order.client.lastname},\n E-mail ${order.client.email},\n\n  === Datos de Orden === \n\n id: ${order.id},\n Fecha: ${order.timestamp},\n Lugar de la Cita:${order.address.address} \n\n',
      );
      ResponseApi reportResponse =
          await _reporteProvider.addReportClient(reportsHasReports);
      if (reportResponse.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Se ha generado un reporte de la orden cancelada ${reportResponse.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange[800],
        ));
      } else {
        _progressDialog.close();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${reportResponse.message}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${responseApi.message}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen[900],
      ));
      Navigator.of(context).pop();
      _progressDialog.close();
      // Cerrar la pantalla actual después de 2 segundos
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, 'agente/gestiones/list', (route) => false);
      });
    } else {
      _progressDialog.close();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${responseApi.message}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }
  }

  void isCloseToAgentePosition() {
    _distanceBetween = Geolocator.distanceBetween(_position.latitude,
        _position.longitude, order.address.lat, order.address.lng);
    print('--------- Distancia: ${_distanceBetween}---------');
  }

  void llamarAgente() {
    final uri = Uri.parse("tel://${order.agent.phone}");
    launchUrl(uri);
  }

  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints()
        .getRouteBetweenCoordinates(Entorno.API_KEY_MAPS, pointFrom, pointTo);

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: ColorsTheme.lightColor,
        points: points,
        width: 5);

    polylines.add(polyline);

    refresh();
  }

  void addMarker(String markerId, double lat, double lng, String tittle,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: tittle, snippet: content));
    markers[id] = marker;

    refresh();
  }

// Posible Error

  void selectPuntoReferencia() {
    if (_mapController.isCompleted) {
      Map<String, dynamic> data = {
        'address': addressName,
        'lat': addressLatLng.latitude,
        'lng': addressLatLng.longitude,
      };

      Navigator.pop(context, data);
    } else {
      print('El controlador del mapa no se ha completado');
    }
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String ruta) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, ruta);
    return descriptor;
  }

  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);

      if (address != null) {
        if (address.length > 0) {
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String department = address[0].administrativeArea;
          String country = address[0].country;
          addressName = '$direction # $street, $city, $department, $country';
          addressLatLng = new LatLng(lat, lng);

          print('Latitud:${addressLatLng.latitude}');
          print('Longitud:${addressLatLng.longitude}');

          refresh();
        }
      }
    }
  }

// End of Posible Error

//Estilo de Mapa
  void onMapCreated(GoogleMapController controller) {
    /* controller.setMapStyle(
        '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]'); */
    _mapController.complete(controller);
  }

  void dispose() {
    socket?.disconnect();
  }

  void updateLocation() async {
    try {
      await _determinePosition(); //Obtieniendo la posicion actual

      /*  addMarker('Agente Inmobiliario', _position.latitude, _position.longitude,
          'Tu Posición', '', agentMarker);*/

      animateCamaraToPosition(order.lat, order.lng);

      addMarker('Agente Inmobiliario', order.lat, order.lng,
          'Agente Inmobiliario', '', agentMarker);

      addMarker('Cliente', order.address.lat, order.address.lng,
          'punto de encuentro', '', puntoEncuentroMarker);
      LatLng from = new LatLng(order.lat, order.lng);
      LatLng to = new LatLng(order.address.lat, order.address.lng);

      setPolylines(from, to);
      refresh();
    } catch (error) {
      print(
          'Ocurrio Un error al obtener la posición en el controlador del cliente direccione mapa controlador, El error que se generó es: $error');
    }
  }

  //Preguntar al usuario para activar el GPS

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  Future animateCamaraToPosition(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15, bearing: 0)));
    }
  }

//Método para gelocalizar la pocisión en el mapa

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission()
          .then((value) {})
          .onError((error, stackTrace) {
        print(
            'Ha ocurrido un error al obtener ubicación actual del usuario el siguiente error es: $error');
      });
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
