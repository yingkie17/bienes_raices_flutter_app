import 'package:bienes_raices_app/imports/imports.dart';
import 'package:bienes_raices_app/src/modelos/reporte_model.dart';
import 'package:flutter/material.dart';

class InmobiliariaReportesAgenteDetallePage extends StatelessWidget {
  ReportsHasReports reportData;

  InmobiliariaReportesAgenteDetallePage({Key key, @required this.reportData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Reportes'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildField(
                        'Tipo de Reporte:',
                        reportData.categoryReport?.nameReport ??
                            'No Disponible'),
                    _buildRowField('ID:', reportData.id),
                  ],
                ),
                _buildField('Fecha de Reporte:',
                    reportData?.dateReport ?? ' No disponible'),

                _buildField('Nombre del Reporte:',
                    reportData?.nameReport ?? 'No Disponible'),
                _buildField('Descripción del Reporte:',
                    reportData?.descriptionReport ?? 'No Disponible'),
                reportData.agent?.id != null && reportData.agent.id.isNotEmpty
                    ? _buildAgentField()
                    : Container(), // Contenedor vacío si no hay ID del agente
                reportData.agent?.id != null && reportData.agent.id.isNotEmpty
                    ? SizedBox(height: 16)
                    : Container(),
                reportData.client?.id != null && reportData.client.id.isNotEmpty
                    ? _buildClientField()
                    : Container(),

                reportData.client?.id != null && reportData.client.id.isNotEmpty
                    ? SizedBox(height: 16)
                    : Container(),
                reportData.product?.id != null &&
                        reportData.product.id.isNotEmpty
                    ? _buildProductField()
                    : Container(),
                reportData.product?.id != null &&
                        reportData.product.id.isNotEmpty
                    ? SizedBox(height: 16)
                    : Container(),
                _buildCategoryReportField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Agente',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'ID: ${reportData.agent.id ?? ""}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Nombre: ${reportData.agent?.name ?? ""}, ${reportData.agent?.lastname}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Documento Identidad: ${reportData.agent?.identity_card ?? ""}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Correo Electrónico: ${reportData.agent?.email ?? ""}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Telefono: ${reportData.agent?.phone ?? ""}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del Cliente',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'ID: ${reportData.agent.id ?? ""}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Nombre: ${reportData.agent?.name ?? ""}, ${reportData.agent?.lastname}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Documento Identidad: ${reportData.agent?.identity_card ?? ""}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Correo Electrónico: ${reportData.agent?.email ?? ""}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Telefono: ${reportData.agent?.phone ?? ""}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  } // Implementa el magent

  Widget _buildProductField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información de Producto',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'ID: ${reportData.product?.id ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Título de Anuncio: ${reportData.product?.nameProduct ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Precio: ${reportData.product?.priceProduct ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Comisión: ${reportData.product?.commissionProduct ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Ciudad: ${reportData.product?.cityProduct ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Dirección: ${reportData.product?.addressProduct ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Teléfono de Referencia: ${reportData.product?.phoneProduct ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Superficie M²: ${reportData.product?.areaProduct ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Nombre Propietario: ${reportData.product?.nameOwner ?? "No Disponible"}, ${reportData.product?.lastnameOwner ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Telefono Propietario: ${reportData.product?.phoneOwner ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Correo electrónico propietario: ${reportData.product?.emailOwner ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'CI Propietario: ${reportData.product?.ciOwner ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Número de Contrato: ${reportData.product?.idContract ?? "No Disponible"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 4),
            Text(
              'Descripción: ${reportData.product?.descriptionProduct ?? "No Disponible"}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: 'Roboto',
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryReportField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
        color: Colors.blueGrey, // Agrega un fondo de color azul grisáceo
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categoría de Reporte',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Cambia el color del texto a blanco
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Tipo de Reporte: ',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white), // Cambia el color del texto a blanco
                ),
                Flexible(
                  child: Text(
                    reportData.categoryReport?.nameReport ?? "No Disponible",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color:
                            Colors.white), // Cambia el color del texto a blanco
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Descrípcion: ',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), // Cambia el color del texto a blanco
            ),
            SizedBox(height: 4),
            Text(
              '${reportData.categoryReport?.descriptionReport ?? "No disponible"}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white), // Cambia el color del texto a blanco
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  } //
}
