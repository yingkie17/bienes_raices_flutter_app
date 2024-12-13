import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/src/modelos/producto.dart';
import 'package:bienes_raices_app/src/vistas/cliente/propiedades/detalle/cliente_propiedades_detalle_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ClientePropiedadesDetallePage extends StatefulWidget {
  Product product;

  ClientePropiedadesDetallePage({Key key, @required this.product})
      : super(key: key);

  @override
  State<ClientePropiedadesDetallePage> createState() =>
      _ClientePropiedadesDetallePageState();
}

class _ClientePropiedadesDetallePageState
    extends State<ClientePropiedadesDetallePage> {
  ClientePropiedadesDetalleController _controlador =
      new ClientePropiedadesDetalleController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controlador.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageSlideshow(),
              _nombreProducto(),

              //Precio Producto
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 10, right: 15),
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Expanded(child: _precioProducto()),
              ),

              //Ciudad Producto
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.place_outlined,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'Ciudad:',
                      style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.primaryColor,
                      ),
                    ),
                    Expanded(child: _ciudadProducto()),
                  ],
                ),
              ),

              //Dirección Producto
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.map_outlined,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Dirección:',
                      style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.primaryColor,
                      ),
                    ),
                    Expanded(child: _direccionProducto()),
                  ],
                ),
              ),

              //Ciudad Producto
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.phone_android_outlined,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Teléfono:',
                      style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.primaryColor,
                      ),
                    ),
                    Expanded(child: _telefonoProducto()),
                  ],
                ),
              ),

              //Superficie Producto
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.square_foot_rounded,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Superficie:',
                      style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.primaryColor,
                      ),
                    ),
                    Expanded(child: _superficieProducto()),
                  ],
                ),
              ),

              //Comisión Producto
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Comisión:',
                      style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.primaryColor,
                      ),
                    ),
                    Expanded(child: _comisionProducto()),
                  ],
                ),
              ),

              //Descripcion Producto
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.description_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Descripción:',
                      style: TextStyle(
                        fontFamily: 'NimbusSans',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: ColorsTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              _descripcionProducto(),
              SizedBox(
                height: 15,
              ),

              //Asistente de Profesionales
              _contactarAgente(),
              _llamarPropiedadButton(),
              _guardarPropiedadButton(),

              SizedBox(
                height: 40,
              ),

              ////////
            ],
          ),
        ));
  }

  // Método Carrusel de Imagenes  Ventana Modal
  Widget _imageSlideshow() {
    return Stack(
      children: [
        ImageSlideshow(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          initialPage: 0,
          indicatorColor: ColorsTheme.secondaryColor,
          indicatorBackgroundColor: Colors.grey,
          children: [
            FadeInImage(
              image: _controlador.product?.imageProduct1 != null
                  ? NetworkImage(_controlador.product.imageProduct1)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct2 != null
                  ? NetworkImage(_controlador.product.imageProduct2)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct3 != null
                  ? NetworkImage(_controlador.product.imageProduct3)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct4 != null
                  ? NetworkImage(_controlador.product.imageProduct4)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct5 != null
                  ? NetworkImage(_controlador.product.imageProduct5)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
            FadeInImage(
              image: _controlador.product?.imageProduct6 != null
                  ? NetworkImage(_controlador.product.imageProduct6)
                  : AssetImage('lib/assets/images/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('lib/assets/images/no-image.png'),
            ),
          ],
          onPageChanged: (value) {
            print('Página Cambiada: $value');
          },
          autoPlayInterval: 70000,
          isLoop: true,
        ),

        // Back Arrow ir Atrás
        Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              onPressed: _controlador.close,
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white70,
            ))
      ],
    );
  }

  // Título Propiedad o Producto

  Widget _nombreProducto() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Text(
        _controlador.product?.nameProduct ?? 'No Contiene iformación',
        maxLines: 2,
        style: TextStyle(
            fontFamily: 'NimbusSans',
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black87),
      ),
    );
  }

  // Descripcion de Propiedad o Producto

  Widget _descripcionProducto() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white10,
      ),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        _controlador.product?.descriptionProduct ?? 'No Contiene iformación',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  // Ciudad Propiedad o Producto
  Widget _ciudadProducto() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        _controlador.product?.cityProduct ?? 'No Contiene iformación',
        style: TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  // Dirección Propiedad o Producto
  Widget _direccionProducto() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        _controlador.product?.addressProduct ?? 'No Contiene iformación',
        style: TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  // Precio Propiedad o Producto
  Widget _precioProducto() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        '\$ ${_controlador.productPrice ?? 0.0}',
        style: TextStyle(
          fontSize: 35,
          color: ColorsTheme.primaryDarkColor,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  // Comision Propiedad o Producto
  Widget _comisionProducto() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        _controlador.product?.commissionProduct.toString() ??
            'No Contiene iformación',
        style: TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  // Teléfono Propiedad o Producto
  Widget _telefonoProducto() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        _controlador.product?.phoneProduct ?? 'No Contiene iformación',
        style: TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  // Superficie Propiedad o Producto
  Widget _superficieProducto() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        '${_controlador.product?.areaProduct ?? 'No Contiene iformación'} m²',
        style: TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  // Contactar Cita Con Agente
  Widget _contactarAgente() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      child: Row(
        children: [
          Image.asset(
            'lib/assets/images/AgentProfile.png',
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'Asistencia Profesional',
              style: TextStyle(
                color: ColorsTheme.primaryDarkColor,
                fontSize: 14,
                fontFamily: 'NimbusSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  //BotonRealizarCitaAgente

  Widget _llamarPropiedadButton() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        child: ElevatedButton(
          onPressed: _controlador.llamarCliente,
          style: ElevatedButton.styleFrom(
              primary: ColorsTheme.secondaryColor,
              padding: EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'LLamar Consultar',
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
                  margin: EdgeInsets.only(left: 30, top: 7),
                  height: 30,
                  child: Icon(Icons.phone),
                ),
              )
            ],
          ),
        ));
  }

  //BotonRealizarCitaAgente

  Widget _guardarPropiedadButton() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 60, vertical: 5),
        child: ElevatedButton(
          onPressed: _controlador.addToBag,
          style: ElevatedButton.styleFrom(
              primary: ColorsTheme.secondaryColor,
              padding: EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'AGREGAR A LA BOLSA',
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
                  margin: EdgeInsets.only(left: 30, top: 7),
                  height: 30,
                  child: Image.asset('lib/assets/images/bag.png'),
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
