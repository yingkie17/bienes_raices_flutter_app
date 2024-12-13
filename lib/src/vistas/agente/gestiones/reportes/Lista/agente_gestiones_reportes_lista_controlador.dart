import 'dart:async';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:bienes_raices_app/src/modelos/reportes_moldel.dart';
import 'package:bienes_raices_app/src/modelos/user_modelo.dart';
import 'package:bienes_raices_app/src/provider/reportes_provider.dart';
import 'package:bienes_raices_app/src/shared_preferences/shared_preferences.dart';

import 'package:bienes_raices_app/src/vistas/agente/gestiones/reportes/detalle_reporte/agente_gestiones_reportes_detalle_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class AgenteGestionesReportesController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  Function refresh;
  User user;
  ProgressDialog _progressDialog;
  ReporteProvider _reporteProvider = new ReporteProvider();
  List<Reports> listReports = [];
  List<ReportsHasReports> listYearsReports = [];
  String selectedReportId;
  String selectedYear;
  int selectedDay;
  String id_reports;
  String id_agent;
  int selectedStartDay;
  int selectedEndDay;
  String selectedStartMonth;
  int selectedmouthStartNumber;
  int selectedmouthEndNumber;
  String selectedEndMonth;
  String selectedStartYear;
  String selectedEndYear;
  String nombreReport = '';
  List<ReportsHasReports> filteredReports = [];
  List<MapEntry<String, int>> monthList = [
    MapEntry('Enero', 1),
    MapEntry('Febrero', 2),
    MapEntry('Marzo', 3),
    MapEntry('Abril', 4),
    MapEntry('Mayo', 5),
    MapEntry('Junio', 6),
    MapEntry('Julio', 7),
    MapEntry('Agosto', 8),
    MapEntry('Septiembre', 9),
    MapEntry('Octubre', 10),
    MapEntry('Noviembre', 11),
    MapEntry('Diciembre', 12),
  ];

  //Método para seleccionar el numero del nombre del mes

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));

    _reporteProvider.init(context, user);
    id_agent = user.id;
    await getAllTypeReports();
    await getYearsReports();
  }

  void onMonthChange(String monthName) {
    selectedStartMonth = monthName;
    selectedmouthStartNumber =
        monthList.firstWhere((entry) => entry.key == monthName).value;
    refresh(); // Actualiza la vista si es necesario
  }

  Future<void> getAllTypeReports() async {
    listReports = await _reporteProvider.getAllReportsByTypeAgent();
    refresh();
  }

  Future<void> getYearsReports() async {
    listYearsReports = await _reporteProvider.getReportYears();
    refresh();
  }

//Metodo para Generar Reporte

  void generarReporte() async {
    _progressDialog = new ProgressDialog(context: context);
    // Validación de la entrada del usuario (opcional)
    if (selectedReportId == null ||
        selectedStartDay == 0 ||
        selectedEndDay == 0 ||
        selectedmouthStartNumber == null ||
        selectedmouthEndNumber == null ||
        selectedStartYear == null ||
        selectedEndYear == null) {
      // Mostrar un mensaje de error o un diálogo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecciona todos los campos requeridos.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ),
      );
      print(
          '$selectedReportId, $selectedStartDay, $selectedEndDay, $selectedmouthStartNumber, $selectedmouthEndNumber, $selectedStartYear, $selectedEndYear');
      return;
    }

    if (selectedStartDay < 1 || selectedStartDay > 31) {
      print('No seleccionaste un dia valido PERIODO INICIO');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('No seleccionaste un dia valido en el periodo de inicio.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
        ),
      );
      return;
    }
    if (selectedEndDay < 1 || selectedEndDay > 31) {
      print('No seleccionaste un dia valido PERIODO FIN');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
          content: Text(
              'No seleccionaste un dia valido en el periodo de finalización.'),
        ),
      );
      return;
    }

    if (int.parse(selectedEndYear) == int.parse(selectedStartYear)) {
      if (selectedmouthStartNumber > selectedmouthEndNumber) {
        print('El mes de periodo de inicio es mayor al de periodo final');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[600],
            content: Text(
                'El mes de periodo de inicio es mayor al de periodo final.'),
          ),
        );
        return;
      }
      if (selectedEndMonth == selectedStartMonth) {
        if (selectedEndDay < selectedStartDay) {
          print('El dia de periodo de inicio es mayor al de periodo final');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red[600],
              content: Text(
                  'El dia de periodo de inicio es mayor al de periodo final.'),
            ),
          );
          return;
        }
      }
    }
    if (int.parse(selectedStartYear) > int.parse(selectedEndYear)) {
      print('El año de periodo de inicio es mayor al de periodo final');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
          content:
              Text('El año de periodo de inicio es mayor al de periodo final.'),
        ),
      );
      return;
    }
    // Construir la fecha de inicio en formato YYYY-MM-DD
    String fechaInicio =
        '$selectedStartYear-${selectedmouthStartNumber.toString().padLeft(2, '0')}-${selectedStartDay.toString().padLeft(2, '0')}';

    // Construir la fecha de fin (ajusta según tu lógica)
    // Supongamos que el usuario selecciona el año, mes y día finales
    String fechaFin =
        '$selectedEndYear-${selectedmouthEndNumber.toString().padLeft(2, '0')}-${selectedEndDay.toString().padLeft(2, '0')}'; // Aquí debes implementar la lógica para obtener la fecha final

    // Combinar ambas fechas en un solo string
    String periodo = '$fechaInicio/$fechaFin';

    String getAgentReport = '$id_agent/$selectedReportId/$periodo';
    // Enviar la solicitud al backend
    _progressDialog.show(
      msg: "Obteniendo reportes...",
      progressBgColor: Colors.transparent,
    );
    try {
      filteredReports =
          await _reporteProvider.getAgentReportByPeriod(getAgentReport);
      _progressDialog.close();

      refresh();
    } catch (e) {
      _progressDialog.close(); // Manejar errores
      print('Error al enviar la solicitud: $e');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al enviar la solicitud: $e'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
      ));
      return;
    }
    _progressDialog.close();
  }

//Método para formatear las fecha

  String formatFechaCreacionReporte(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

//Método para ir a detalle de reporte

  void goToReportDetail(ReportsHasReports reportData) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) =>
            AgenteGestionesReportesDetallePage(reportData: reportData));
  }
}
