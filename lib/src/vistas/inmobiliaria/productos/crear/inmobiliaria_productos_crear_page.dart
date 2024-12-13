import 'package:bienes_raices_app/imports/imports.dart';
import 'package:bienes_raices_app/src/modelos/categoria_model.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/productos/crear/inmobiliaria_productos_crear_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class InmobiliariaProductosCrearPage extends StatefulWidget {
  const InmobiliariaProductosCrearPage({Key key}) : super(key: key);

  @override
  State<InmobiliariaProductosCrearPage> createState() =>
      _InmobiliariaProductosCrearPageState();
}

class _InmobiliariaProductosCrearPageState
    extends State<InmobiliariaProductosCrearPage> {
  InmobiliariaProductosCrearControlador _controlador =
      new InmobiliariaProductosCrearControlador();

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
        title: Text('Registrar nueva propiedad'),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              _textDuenoInformacion(),
              SizedBox(height: 15),
              _textFieldNombrePropietarioProducto(),
              SizedBox(height: 15),
              _textFieldApellidosPropietarioProducto(),
              SizedBox(height: 15),
              _textFieldTelefonoPropietarioProducto(),
              SizedBox(height: 15),
              _textFieldCorreoElectronicoPropietarioProducto(),
              SizedBox(height: 15),
              _textFieldCIPropietarioProducto(),
              SizedBox(height: 15),
              _textFieldContratoServicioPropietarioProducto(),
              SizedBox(height: 30),
              _textroductoInformacion(),
              SizedBox(height: 30),
              _textFieldNombreProducto(),
              SizedBox(height: 15),
              _categoriaServicioProducto(_controlador.categories),
              SizedBox(height: 15),
              _textFieldPrecioProducto(),
              SizedBox(height: 15),
              _textFieldComisionProducto(),
              SizedBox(height: 15),
              _textFieldCiudadProducto(),
              SizedBox(height: 15),
              _textFieldDireccionProducto(),
              SizedBox(height: 15),
              _textFieldTelefonoProducto(),
              SizedBox(height: 15),
              _textFieldAreaProducto(),
              SizedBox(height: 15),
              _textFieldDescripcionProducto(),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _tarjetaImagen(_controlador.imageFile1, 1),
                            _tarjetaImagen(_controlador.imageFile2, 2),
                            _tarjetaImagen(_controlador.imageFile3, 3),
                          ]),
                    ),
                    Container(
                      height: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _tarjetaImagen(_controlador.imageFile4, 4),
                          _tarjetaImagen(_controlador.imageFile5, 5),
                          _tarjetaImagen(_controlador.imageFile6, 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              _crearNuevoProductoBoton(),
            ],
          ),
        ),
      ),
    );
  }

  // Méetodo Logo contenedor
  Widget _logoContainer() {
    final _size = MediaQuery.of(context).size;
    return Container(
      child: Image.asset(
        'lib/assets/images/unandesLogo.png',
        width: _size.width * 0.5,
      ),
    );
  }

  // MÉtodo para imagenes
  Widget _imageBuldingApp() {
    final _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        top: _size.height * 0.05,
      ),
      child: Image.asset('lib/assets/images/realEstate.png',
          width: 130, height: 130),
    );
  }

  // Título de de información de prpopietario

  Widget _textroductoInformacion() {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 5, right: 40, left: 40),
      child: Text('Información de la Propiedad',
          style: TextStyle(
            fontSize: 22,
            color: ColorsTheme.primaryDarkColor,
          ),
          textAlign: TextAlign.justify),
    );
  }
// Texto de Información

  Widget _textInformacion() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10, right: 40, left: 40),
      child: Text('Esta opción permite registrar nuevas propiedades',
          style: TextStyle(
            fontSize: 20,
            color: ColorsTheme.primaryDarkColor,
          ),
          textAlign: TextAlign.center),
    );
  }

  //Método de campo de Nombre de nuevo Producto
  Widget _textFieldNombreProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: (_controlador.nombreProductoController),
        maxLength: 255,
        maxLines: 2,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Titúlo de anuncio de propiedad',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10),
          prefixIcon: Icon(
            Icons.list_alt_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de categoria de servicios
  Widget _categoriaServicioProducto(List<Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: ColorsTheme.primaryColor,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Tipo de servicio',
                    style: TextStyle(
                        fontSize: 16, color: ColorsTheme.primaryDarkColor),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: ColorsTheme.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text('Seleccione el tipo de servicio'),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  items: _dropDownItems(categories),
                  value: _controlador.idCategory,
                  onChanged: (option) {
                    setState(() {
                      print('Categoria seleccionada: $option');
                      _controlador.idCategory =
                          option; // Aca se establece el valor seleccionado
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

  //Método para crear menu de categorias desplegables

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: Text(
          category.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsTheme.primaryColor,
          ),
        ),
        value: category.id,
      ));
    });
    return list;
  }

  //Método de campo de precio
  Widget _textFieldPrecioProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.precioProductoController,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Precio en Moneda Local',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.monetization_on_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de comision
  Widget _textFieldComisionProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.comisionProductoiaController,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Comisión en moneda local',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.attach_money_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de ciudad
  Widget _textFieldCiudadProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.ciudadProductoiaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Ciudad de Propiedad',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.map_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de dirección
  Widget _textFieldDireccionProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.direccionProductoiaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Dirección de propiedad',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.place_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de telefono
  Widget _textFieldTelefonoProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.celularProductoiaController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Número de celular contacto de agente',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.phone_android_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de área
  Widget _textFieldAreaProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.superficieProductoiaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Superfice metros cuadrados de la propiedad',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.yard_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de nombre de categoría
  Widget _textFieldDescripcionProducto() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.descripcionProductoiaController,
        maxLength: 255,
        maxLines: 8,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Descripción de propiedad',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.description_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  // Título de de información de prpopietario

  Widget _textDuenoInformacion() {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 5, right: 40, left: 40),
      child: Text('Información de Propietario',
          style: TextStyle(
            fontSize: 22,
            color: ColorsTheme.primaryDarkColor,
          ),
          textAlign: TextAlign.justify),
    );
  }
  // Título de de información de prpopietario

  Widget _textTituloDescription() {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 30, right: 40, left: 40),
      child: Text(
          'La información de cliente propietario solo esta disponible para personal de la empresa que cuenta con los permisos, los clientes no verán la inforación del cliente.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.redAccent,
          ),
          textAlign: TextAlign.justify),
    );
  }

  //Método de campo de nombre propietario
  Widget _textFieldNombrePropietarioProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.nombrePropietarioProductoiaController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryColor),
          hintText: 'Nombre del propietario',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.person,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de apellidos propietario
  Widget _textFieldApellidosPropietarioProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.apellidosPropietarioController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Apellido del propietario',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.person_outline_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de telefono de propietario producto
  Widget _textFieldTelefonoPropietarioProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.celularPropietarioController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Número de celular del propietario',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.phone_android_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método de campo de correo electrónico propietario
  Widget _textFieldCorreoElectronicoPropietarioProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.correoPropietarioprecioController,
        maxLength: 60,
        maxLines: 1,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Correo electrónico de Propietario',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
        validator: (value) {
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

          RegExp regExp = new RegExp(pattern);

          return regExp.hasMatch(value ?? '')
              ? null
              : 'Correo electrónico no es válido';
        },
      ),
    );
  }

  //Método de campo de carnet de identidad propietario
  Widget _textFieldCIPropietarioProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.carnetIdentidadPropietarioController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Carnet de identidad del propietario',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.card_membership_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

//Método de campo de numero de contrato de servicio propietario
  Widget _textFieldContratoServicioPropietarioProducto() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsTheme.primaryOpacityColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _controlador.numContratoPropietarioController,
        maxLength: 60,
        maxLines: 2,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
          hintText: 'Código de contrato de servicio',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(
            Icons.insert_drive_file_outlined,
            color: ColorsTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  //Método para agregar Imagenes

  Widget _tarjetaImagen(File imageFile, int numberFile) {
    return GestureDetector(
      onTap: () {
        _controlador.showAlertDialog(numberFile);
      },
      child: imageFile != null
          ? Card(
              elevation: 3.0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.26,
                height: 150,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Card(
              elevation: 3.0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.26,
                height: 140,
                child: Image(
                  image: AssetImage('lib/assets/images/add_image.png'),
                ),
              ),
            ),
    );
  }

  //Método para el ElevateButton de registró de nueva categoría
  Widget _crearNuevoProductoBoton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.all(50),
      child: ElevatedButton(
        onPressed: _controlador.crearProducto,
        child: Text('Registrar Propiedad'),
        style: ElevatedButton.styleFrom(
            primary: ColorsTheme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
