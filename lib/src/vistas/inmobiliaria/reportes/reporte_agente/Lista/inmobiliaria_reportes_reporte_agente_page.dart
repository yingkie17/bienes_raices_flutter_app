import 'package:bienes_raices_app/assets/colors/colors.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/reportes_moldel.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'inmobiliaria_reportes_reporte_agente_controlador.dart';

class InmobiliariaReportesAgenteListaPage extends StatefulWidget {
  const InmobiliariaReportesAgenteListaPage({Key key}) : super(key: key);

  @override
  State<InmobiliariaReportesAgenteListaPage> createState() =>
      _InmobiliariaReportesAgenteListaPageState();
}

class _InmobiliariaReportesAgenteListaPageState
    extends State<InmobiliariaReportesAgenteListaPage> {
  InmobiliariaReportesAgenteListaController _controlador =
      InmobiliariaReportesAgenteListaController();
  String _selectedAgenteId;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controlador.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reportes de Agente: ${_controlador.filteredReports.length ?? ''}',
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        color: ColorsTheme.primaryOpacityColor,
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Fecha de inicio de perido de reporte',
                      style: TextStyle(
                        fontFamily: 'NimbusSnas',
                        fontSize: 13,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _textFieldStartDay(),
                        _dropDownStartPeriodMonth(),
                        _dropDownStartPeriodYears(
                            _controlador.listYearsReports),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Fecha de Finalización de perido de reporte',
                      style: TextStyle(
                        fontFamily: 'NimbusSnas',
                        fontSize: 13,
                        color: ColorsTheme.primaryDarkColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textFieldEndDay(),
                        _dropDownEndPeriodMonth(),
                        _dropDownEndPeriodYears(_controlador.listYearsReports),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _dropUserDown(_controlador.users),
                        _dropDownTypeReport(_controlador.listReports),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _botonGenerarReporte(),

                  //Tipo de Reporte
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(
              context,
            ).size.height *
            0.61,
        child: ListView.builder(
          itemCount: _controlador.filteredReports.length,
          itemBuilder: (context, index) {
            final report = _controlador.filteredReports[index];
            return _tarjetasReportes(report);
          },
        ),
      )),
    );
  }

  Widget _dropDownTypeReport(List<Reports> reports) {
    bool isSelected = _controlador.selectedReportId != null;
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.red, // Borde rojo si no hay selección
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          height: 55,
          padding: EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButton<String>(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down_circle,
                        color: ColorsTheme.primaryColor),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text('Tipo de Reporte'),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  items: _dropDownItems(reports),
                  value: _controlador.selectedReportId,
                  onChanged: (option) {
                    setState(() {
                      print('Tipo de Reporte Seleccionado: $option');
                      _controlador.selectedReportId = option;
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

  List<DropdownMenuItem<String>> _dropDownItems(List<Reports> reports) {
    List<DropdownMenuItem<String>> list = [];
    reports.forEach((report) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              child: Text(
                report.nameReport,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
        value: report.id,
      ));
    });
    return list;
  }

  Widget _textFieldStartDay() {
    bool isSelected = _controlador.selectedStartDay != null;
    return Container(
      width: MediaQuery.of(context).size.width * 0.30,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.red, // Borde rojo si no hay selección
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          height: 55,
          child: TextFormField(
            autocorrect: false,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Día',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              suffixIcon: Icon(
                Icons.date_range,
                color: ColorsTheme.primaryColor,
              ),
              errorStyle: TextStyle(
                color: Colors.red,
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingrese el día';
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Día Invalido';
              } else if (int.parse(value) < 1 || int.parse(value) > 31) {
                return 'Día Invalido';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _controlador.selectedStartDay = int.tryParse(value) ?? 0;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _textFieldEndDay() {
    bool isSelected = _controlador.selectedEndDay != null;
    return Container(
      width: MediaQuery.of(context).size.width * 0.30,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.red, // Borde rojo si no hay selección
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            autocorrect: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Día',
              alignLabelWithHint: true, // Esto alinea el label con el hint
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              suffixIcon: Icon(
                Icons.date_range,
                color: ColorsTheme.primaryColor,
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingrese el día';
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Día Invalido';
              } else if (int.parse(value) < 1 || int.parse(value) > 31) {
                return 'Día Invalido';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _controlador.selectedEndDay = int.tryParse(value) ?? 0;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _dropDownStartPeriodMonth() {
    bool isSelected = _controlador.selectedStartMonth != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width * 0.32,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.red, // Borde rojo si no hay selección
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButton<String>(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down_circle,
                        color: ColorsTheme.primaryColor),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text('Mes'),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  items: _controlador.monthList.map<DropdownMenuItem<String>>(
                      (MapEntry<String, int> entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(
                        entry.key,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                  value: _controlador.selectedStartMonth,
                  onChanged: (option) {
                    setState(() {
                      print('Mes de Inicio de Reporte Seleccionado: $option');
                      _controlador.onMonthChange(option);
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

  Widget _dropDownEndPeriodMonth() {
    bool isSelected = _controlador.selectedEndMonth != null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width * 0.32,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.red, // Borde rojo si no hay selección
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButton<String>(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down_circle,
                        color: ColorsTheme.primaryColor),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text('Mes'),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  items: _controlador.monthList.map<DropdownMenuItem<String>>(
                      (MapEntry<String, int> entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(
                        entry.key,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                  value: _controlador.selectedEndMonth,
                  onChanged: (option) {
                    setState(() {
                      print(
                          'Mes de finalización de Reporte Seleccionado: $option');
                      _controlador.selectedEndMonth = option;
                      _controlador.selectedmouthEndNumber = _controlador
                          .monthList
                          .firstWhere((element) => element.key == option)
                          .value;
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

  Widget _dropDownStartPeriodYears(List<ReportsHasReports> listYearsReports) {
    bool isSelected = _controlador.selectedStartYear != null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width * 0.27,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.red, // Borde rojo si no hay selección
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down_circle,
                        color: ColorsTheme.primaryColor),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text('Año'),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  items: _dropDownYearsItems(listYearsReports),
                  value: _controlador.selectedStartYear,
                  onChanged: (option) {
                    setState(() {
                      print('Año de Inicio de Reporte Seleccionado: $option');
                      _controlador.selectedStartYear = option;
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

  Widget _dropDownEndPeriodYears(List<ReportsHasReports> listYearsReports) {
    bool isSelected = _controlador.selectedEndYear != null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width * 0.27,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.red, // Borde rojo si no hay selección
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down_circle,
                        color: ColorsTheme.primaryColor),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text('Año'),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  items: _dropDownYearsItems(listYearsReports),
                  value: _controlador.selectedEndYear,
                  onChanged: (option) {
                    setState(() {
                      print(
                          'Año de finalización de Reporte Seleccionado: $option');
                      _controlador.selectedEndYear = option;
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

  List<DropdownMenuItem<String>> _dropDownYearsItems(
      List<ReportsHasReports> listYearsReports) {
    List<DropdownMenuItem<String>> list = [];
    listYearsReports.forEach((reports_has_report) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              child: Text(
                reports_has_report.year,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
        value: reports_has_report.year.toString(),
      ));
    });
    return list;
  }

  //Boton para generar reporte

  Widget _botonGenerarReporte() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 55,
      child: ElevatedButton(
        onPressed: _controlador.generarReporte,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(10),
          elevation: 6,
          // Ajusta el padding si es necesario
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_chart), // Icono que quieres mostrar
            SizedBox(width: 8), // Espacio entre el icono y el texto (opcional)
            Text("Generar Reporte"), // Texto que acompaña al botón (opcional)
          ],
        ),
      ),
    );
  }

  //Método de tarjetas para los reportes de agente

  Widget _tarjetasReportes(ReportsHasReports reportsHasReports) {
    return GestureDetector(
      onTap: () {
        _controlador.goToReportDetail(reportsHasReports);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            height: 250,
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              color: Colors.white70,
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColorsTheme.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: Text(
                              'Tipo de Reporte: ${reportsHasReports.categoryReport.nameReport}', // Muestra el nombre del reporte
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: Text(
                              'ID: ${reportsHasReports.id}', // Muestra el ID del reporte
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 55),
                    padding: EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Text(
                                      'Fecha de Reporte: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      '${reportsHasReports.dateReport ?? ''}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text('Agente: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Expanded(
                                  child: Text(
                                '${reportsHasReports.agent.name ?? ''} , ${reportsHasReports.agent.lastname ?? ''}',
                              )), // Reemplaza con el nombre del agente si está disponible
                            ],
                          ),
                          SizedBox(height: 4),
                          Container(
                            child: Text(
                              'Detalle de tipo de reporte: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '${reportsHasReports.nameReport ?? 'No disponible'}', // Reemplaza con la descripción del tipo de reporte
                          ),
                          SizedBox(height: 4),
                          Container(
                            child: Text(
                              'Descripción de Reporte: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '${reportsHasReports.descriptionReport ?? 'No disponible'}', // Reemplaza con la descripción detallada del reporte
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropUserDown(List<User> users) {
    bool isSelected = _controlador.selected_id_agent != null;
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : Colors.red, // Borde rojo si no hay selección
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                width: double.infinity,
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
                  hint: Text('Agente'),
                  style: TextStyle(fontSize: 14),
                  items: _dropDownUsersItems(users),
                  value: _controlador.selected_id_agent,
                  onChanged: (option) {
                    setState(() {
                      print('Agente Seleccionado: $option');
                      _controlador.selected_id_agent = option;
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

  List<DropdownMenuItem<String>> _dropDownUsersItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 55,
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
                '${user.name} ${user.lastname}',
                maxLines: 3,
                style: TextStyle(
                    fontSize: 12,
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

  void refresh() {
    setState(() {});
  }
}
