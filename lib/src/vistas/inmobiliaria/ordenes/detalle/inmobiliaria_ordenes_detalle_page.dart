import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/assets/widgets/no_data_widgets.dart';
import 'package:bienes_raices_app/src/modelos/order_model.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/ordenes/detalle/Inmobiliaria_ordenes_detalle_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intl/intl.dart';
import 'package:bienes_raices_app/assets/timeStamp/relative_time_util.dart';

class InmobiliariaOrdenesDetallePage extends StatefulWidget {
  Order order;
  InmobiliariaOrdenesDetallePage({Key key, @required this.order})
      : super(key: key);

  @override
  State<InmobiliariaOrdenesDetallePage> createState() =>
      _InmobiliariaOrdenesDetallePageState();
}

class _InmobiliariaOrdenesDetallePageState
    extends State<InmobiliariaOrdenesDetallePage> {
  InmobiliariaOrdenesDetalleController _controlador =
      new InmobiliariaOrdenesDetalleController();
  String _selectedAgenteId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controlador.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket #${_controlador.order?.id ?? ''} '),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 20, right: 15),
            child: Text(
              '${RelativeTimeUtil.getRelativeTime(_controlador.order?.timestamp ?? 0)} ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: _controlador.order?.status != 'Espera'
            ? MediaQuery.of(context).size.height * 0.35
            : MediaQuery.of(context).size.height * 0.42,
        color: ColorsTheme.primaryOpacityColor,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: Alignment.centerLeft,
                  child: _controlador.order?.status != 'Espera'
                      ? Text(
                          'Agente asignado:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NimbusSnas',
                              fontSize: 17,
                              fontStyle: FontStyle.italic,
                              color: ColorsTheme.lightColor),
                        )
                      : Text(
                          'Asignar Agente Inmobiliario:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NimbusSnas',
                              fontSize: 16,
                              color: ColorsTheme.primaryDarkColor),
                        ),
                ),
                SizedBox(
                  height: 5,
                ),
                _controlador.order?.status != 'Espera'
                    ? _agentData()
                    : Container(),
                _controlador.order?.status == 'Espera'
                    ? _dropDown(_controlador.users)
                    : Container(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Datos del cliente que generó el ticket:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NimbusSnas',
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                  ),
                ),
                _infoCliente(),
                _controlador.order?.status == 'Curso' ||
                        _controlador.order?.status == 'Concretado' ||
                        _controlador.order?.status == 'Cancelado'
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                      )
                    : _consultarButton(),
              ],
            ),
          ),
        ),
      ),
      body: _controlador.order?.products?.length != null
          ? ListView(
              children: _controlador.order?.products?.map((Product product) {
                return _tarjetaOrdenes(product);
              })?.toList(),
            )
          : Container(
              margin: EdgeInsets.only(top: 30),
              child: NoDataWidets(
                text: 'Ninguna propiedad fue agregada a la bolsa de consultas ',
              ),
            ),
    );
  }

//Método Con información de cliente

  Widget _infoCliente() {
    final clientName = _controlador.order?.client?.name ?? 'Sin nombre';
    final clientLastName =
        _controlador.order?.client?.lastname ?? 'Sin Apellido';
    final clientPhone = _controlador.order?.client?.phone ?? 'Sin Teléfono';
    final clientEmail = _controlador.order?.client?.email ?? 'Sin Email';
    final addressClient = _controlador.order?.address?.address ?? 'Sin Calle';
    final zonaClient = _controlador.order?.address?.neighborhood ?? 'Sin Zona';
    String formattedDate = '';
    if (_controlador.order != null && _controlador.order.address != null) {
      formattedDate =
          DateFormat('dd-MM-yyyy').format(_controlador.order.address.dateEvent);
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                'Cliente:',
                style: TextStyle(
                    fontFamily: 'NimbusSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorsTheme.primaryColor),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '$clientName $clientLastName',
                  maxLines: 2,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'NimbusSans',
                      fontSize: 14,
                      color: Colors.grey[900]),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                'Teléfono:',
                style: TextStyle(
                    fontFamily: 'NimbusSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorsTheme.primaryColor),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '$clientPhone',
                maxLines: 3,
                style: TextStyle(
                    fontFamily: 'NimbusSans',
                    fontSize: 14,
                    color: Colors.grey[900]),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                'Email:',
                style: TextStyle(
                    fontFamily: 'NimbusSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorsTheme.primaryColor),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '$clientEmail',
                  maxLines: 2,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'NimbusSans',
                      fontSize: 14,
                      color: Colors.grey[900]),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                'Punto de Encuentro:',
                style: TextStyle(
                    fontFamily: 'NimbusSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorsTheme.primaryColor),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '$addressClient ' '$zonaClient',
                  maxLines: 4,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'NimbusSans',
                      fontSize: 14,
                      color: Colors.grey[900]),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    'Hora:',
                    style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: ColorsTheme.primaryColor),
                  ),
                  Text(
                    _controlador.order?.address?.timeEvent != null
                        ? DateFormat('HH:mm').format(
                            DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              _controlador.order.address.timeEvent.hour,
                              _controlador.order.address.timeEvent.minute,
                            ),
                          )
                        : 'Sin hora',
                    maxLines: 5,
                    style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontSize: 14,
                        color: Colors.grey[900]),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Row(
                children: [
                  Text(
                    'Fecha:',
                    style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: ColorsTheme.primaryColor),
                  ),
                  Text(
                    '$formattedDate',
                    maxLines: 5,
                    style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontSize: 14,
                        color: Colors.grey[900]),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

//Método Dropdown Agente

//Método de campo de categoria de servicios
  Widget _dropDown(List<User> users) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: DropdownButton<String>(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: ColorsTheme.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text('Agentes'),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  items: _dropDownItems(users),
                  value: _controlador.idAgente,
                  onChanged: (option) {
                    setState(() {
                      print('Agente Seleccionado: $option');
                      _controlador.idAgente = option;
                      ;
                      //    _controlador.idCategory = option; // Aca se establece el valor seleccionado
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ... Otro código ...

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: FadeInImage(
                  image: user.image != null && user.image.isNotEmpty
                      ? NetworkImage(user.image)
                      : AssetImage('lib/assets/images/no-image.png'),
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('lib/assets/images/no-image.png'),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                user.name,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'NimbusSans',
                    color: Colors.grey[700],
                    overflow: TextOverflow.fade),
              ),
            ),
            Expanded(
              child: Text(
                user.lastname,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'NimbusSans',
                    color: Colors.grey[700],
                    overflow: TextOverflow.fade),
              ),
            ),
          ],
        ),
        value: user.id,
      ));
    });
    return list;
  }

//
  Widget _agentData() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.green,
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: FadeInImage(
                image: _controlador.order?.agent?.image != null &&
                        _controlador.order.agent.image.isNotEmpty
                    ? NetworkImage(_controlador.order.agent.image)
                    : AssetImage('lib/assets/images/no-image.png'),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('lib/assets/images/no-image.png'),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              '${_controlador.order?.agent?.name ?? ''}',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NimbusSans',
                  color: Colors.grey[900],
                  overflow: TextOverflow.fade),
            ),
          ),
          Expanded(
            child: Text(
              '${_controlador.order?.agent?.lastname ?? ''}',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NimbusSans',
                  color: Colors.grey[900],
                  overflow: TextOverflow.fade),
            ),
          ),
        ],
      ),
    );
  }

// Método Carrusel de Imagenes  Ventana Modal
  Widget _imageSlideshow(Product product) {
    return Stack(
      children: [
        ImageSlideshow(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.2,
          initialPage: 0,
          indicatorColor: ColorsTheme.secondaryColor,
          indicatorBackgroundColor: Colors.grey,
          children: [
            FadeInImage(
              image: product?.imageProduct1 != null &&
                      product.imageProduct1.isNotEmpty
                  ? NetworkImage(product.imageProduct1)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: product?.imageProduct2 != null &&
                      product.imageProduct2.isNotEmpty
                  ? NetworkImage(product.imageProduct2)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: product?.imageProduct3 != null &&
                      product.imageProduct3.isNotEmpty
                  ? NetworkImage(product.imageProduct3)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: product?.imageProduct4 != null &&
                      product.imageProduct4.isNotEmpty
                  ? NetworkImage(product.imageProduct4)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: product?.imageProduct5 != null &&
                      product.imageProduct5.isNotEmpty
                  ? NetworkImage(product.imageProduct5)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: product?.imageProduct6 != null &&
                      product.imageProduct6.isNotEmpty
                  ? NetworkImage(product.imageProduct6)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
          ],
          onPageChanged: (value) {
            print('Foto: $value Cambiada');
          },
          autoPlayInterval: 70000,
          isLoop: true,
        ),
      ],
    );
  }

//Metodo nuevo Tarjeta

  Widget _tarjetaOrdenes(Product product) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 9.1,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(child: _imageSlideshow(product)),
            SizedBox(
              height: 10,
            ),
            Text(
              'Informacion de Orden del Cliente',
              style: TextStyle(
                  fontFamily: 'NimbusSans',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.home_filled,
                        color: ColorsTheme.primaryColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Título propiedad:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '${product?.nameProduct ?? 'Sin Título del Servicio'}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'NimbusSans',
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.category,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Modalidad:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '${product?.category ?? 'Sin modalidad de servicio'}',
                        style: TextStyle(
                            color: Colors.orange,
                            fontFamily: 'NimbusSans',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.assignment,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Código de contrato:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '${product?.idContract ?? 'Sin código de contrato'}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'NimbusSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          color: ColorsTheme.primaryDarkColor),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Precio propiedad:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                          '\$ ${product?.priceProduct != null ? product.priceProduct.toStringAsFixed(2) : '0.0'}',
                          style: TextStyle(
                              fontFamily: 'NimbusSans',
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Comisión agente:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                          '\$ ${product?.commissionProduct != null ? product.commissionProduct.toStringAsFixed(2) : '0.0'}',
                          style: TextStyle(
                              fontFamily: 'NimbusSans',
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Ciudad:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '${product?.cityProduct ?? 'Sin Ciudad'}',
                        style: TextStyle(
                          fontFamily: 'NimbusSans',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Dirección:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                          child: Text(
                        '${product?.addressProduct ?? 'Sin Dirección'}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'NimbusSans',
                        ),
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Teléfono agente:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '${product?.phoneProduct ?? 'Sin Teléfono de referencia'}',
                        style: TextStyle(
                          fontFamily: 'NimbusSans',
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.aspect_ratio,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Superficie:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '${product?.areaProduct ?? 'Sin Área de superficie'} m²',
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'NimbusSans',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Nombre propietario:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '${product?.nameOwner ?? 'Sin nombre de Propietario'} ${product?.lastnameOwner ?? 'Sin Apellido Propietario'}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'NimbusSans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'CI propietario:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '${product.ciOwner ?? 'Sin documento de identidad'}',
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'NimbusSans',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Teléfono propietario:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '${product?.phoneOwner ?? 'Sin teléfono de propietario'}',
                          style: TextStyle(
                            fontFamily: 'NimbusSans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Correo propietario:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '${product?.emailOwner ?? 'Sin Email de Propietario'}',
                          style: TextStyle(
                              color: ColorsTheme.secondaryColor,
                              fontFamily: 'NimbusSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        width: 120,
                        child: Text(
                          'Descripción porpiedad:',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color: ColorsTheme.primaryColor),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '${product?.descriptionProduct ?? 'No contiene Descripción de la Propiedad'}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          style: TextStyle(
                            fontFamily: 'NimbusSans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Puedes agregar más campos aquí si es necesario
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Botón Realizar Consulta de Propiedades

  Widget _consultarButton() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: ElevatedButton(
          onPressed: _controlador.updateOrder,
          style: ElevatedButton.styleFrom(
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
                      'Continuar',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 60, top: 5),
                  height: 30,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void refresh() {
    setState(() {});
  }
}
