import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/assets/widgets/no_data_widgets.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/vistas/cliente/ordenes/crear/cliente_ordenes_crear_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClienteOrdenesCrearPage extends StatefulWidget {
  const ClienteOrdenesCrearPage({Key key}) : super(key: key);

  @override
  State<ClienteOrdenesCrearPage> createState() =>
      _ClienteOrdenesCrearPageState();
}

class _ClienteOrdenesCrearPageState extends State<ClienteOrdenesCrearPage> {
  ClienteOrdenesCrearController _controlador =
      new ClienteOrdenesCrearController();

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
        title: Text('Propiedades Guardadas'),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.19,
        color: ColorsTheme.primaryOpacityColor,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                    'Realizar Consulta, pedir asesoramiento de un agente')),
            _consultarButton(),
          ],
        ),
      ),
      body: _controlador.selectedProducts.length > 0
          ? ListView(
              children: _controlador.selectedProducts.map((Product product) {
                return _cardProduct(product);
              }).toList(),
            )
          : Container(
              margin: EdgeInsets.only(top: 30),
              child: NoDataWidets(
                text: 'Ninguna propiedad fue agregada a la bolsa de consultas ',
              ),
            ),
    );
  }

  Widget _cardProduct(Product product) {
    return SingleChildScrollView(
      child: Container(
        height: 140,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 140,
              height: 140,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: FadeInImage(
                  image: product.imageProduct1 != null
                      ? NetworkImage(product.imageProduct1)
                      : AssetImage('lib/assets/images/no-image.png'),
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('lib/assets/images/no-image.png'),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                height: 190,
                width: 230,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        product.nameProduct ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black87),
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(
                                  left: 0, top: 5, right: 5, bottom: 5),
                              child: Icon(
                                Icons.location_on_outlined,
                                color: Colors.black,
                                size: 20.0,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 180,
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  product.cityProduct ?? '',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 10,
                        width: 230,
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          product.addressProduct ?? '',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: 160,
                            height: 30,
                            alignment: Alignment.topLeft,
                            child: Text(
                              '\$ ${product.priceProduct.toString() ?? ''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsTheme.secondaryColor,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          _eliminarElemento(product),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eliminarElemento(Product product) {
    return Container(
      child: IconButton(
        alignment: Alignment.topCenter,
        onPressed: () {
          _controlador.eliminarElemento(product);
        },
        icon: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  //Botón Realizar Consulta de Propiedades

  Widget _consultarButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: ElevatedButton(
        onPressed: _controlador.selectedProducts.isNotEmpty
            ? _controlador.goToDirecciones
            : null, // Deshabilitar el botón si no hay propiedades seleccionadas
        style: ElevatedButton.styleFrom(
          primary: ColorsTheme.secondaryColor,
          padding: EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
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
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 60, top: 10),
                height: 30,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
