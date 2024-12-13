import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/src/modelos/reportes_moldel.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/reportes/crear/inmobiliaria_reportes_crear_controlador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class InmobiliariaReportesCrearPage extends StatefulWidget {
  const InmobiliariaReportesCrearPage({Key key}) : super(key: key);

  @override
  State<InmobiliariaReportesCrearPage> createState() =>
      _InmobiliariaReportesCrearPageState();
}

class _InmobiliariaReportesCrearPageState
    extends State<InmobiliariaReportesCrearPage> {
  InmobiliariaReportesCrearControlador _controlador =
      new InmobiliariaReportesCrearControlador();

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
        centerTitle: true,
        title: Text(
          'Generar reporte',
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              tituloReporte(),
              _tipoReporte(_controlador.reports),
              descripcionReporte(),
              _generarReporteBoton()
            ],
          ),
        ),
      ),
    );
  }

  //Método de campo de tipo de reportes
  Widget _tipoReporte(List<Reports> reports) {
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
                    'Seleccione el tipo de reporte',
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
                  hint: Text('Seleccione el tipo de reporte'),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  items: _dropDownItems(reports),
                  value: _controlador.idReports,
                  onChanged: (option) {
                    setState(() {
                      print('Reporte seleccionado: $option');
                      _controlador.idReports = option;
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

//Método para crear menu de tipo reportes desplegables

  List<DropdownMenuItem<String>> _dropDownItems(List<Reports> reports) {
    List<DropdownMenuItem<String>> list = [];
    reports.forEach((report) {
      list.add(DropdownMenuItem(
        child: Text(
          report.nameReport,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsTheme.primaryColor,
          ),
        ),
        value: report.id,
      ));
    });
    return list;
  }

//Método para campo de texto de título de reporte

  Widget tituloReporte() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingrese el título de reporte',
            style: TextStyle(
              fontSize: 16,
              color: ColorsTheme.primaryColor,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorsTheme.primaryOpacityColor,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(top: 20),
            child: TextFormField(
              controller: (_controlador.tituloReporteController),
              maxLength: 255,
              maxLines: 2,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
                hintText: 'Asunto ',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                suffixIcon: Icon(
                  Icons.report,
                  color: ColorsTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Método para campo de texto de descripción de reporte

  Widget descripcionReporte() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingrese la descripción del reporte',
            style: TextStyle(
              fontSize: 16,
              color: ColorsTheme.primaryColor,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorsTheme.primaryOpacityColor,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(top: 20),
            child: TextFormField(
              controller: (_controlador.descripcionReporteController),
              maxLength: 255,
              maxLines: 8,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: ColorsTheme.primaryDarkColor),
                hintText: 'Descripción de reporte',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                suffixIcon: Icon(
                  Icons.list_alt_outlined,
                  color: ColorsTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Método para el ElevateButton para generar reporte
  Widget _generarReporteBoton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: ElevatedButton(
        onPressed: (_controlador.generarReporte),
        child: Text('Generar Reporte'),
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
