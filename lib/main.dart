import 'package:bienes_raices_app/imports/imports.dart';
import 'package:bienes_raices_app/src/provider/sever_status_provider.dart';
import 'package:bienes_raices_app/src/vistas/agente/gestiones/mapa/agente_gestiones_mapa_page.dart';
import 'package:bienes_raices_app/src/vistas/agente/gestiones/menu/agente_gestiones_menu_page.dart';
import 'package:bienes_raices_app/src/vistas/agente/gestiones/reportes/Lista/agente_gestiones_reportes_lista_page.dart';
import 'package:bienes_raices_app/src/vistas/agente/gestiones/reportes/detalle_reporte/agente_gestiones_reportes_detalle_page.dart';
import 'package:bienes_raices_app/src/vistas/cliente/direcciones/crear/cliente_direcciones_crear_page.dart';
import 'package:bienes_raices_app/src/vistas/cliente/direcciones/list/cliente_direcciones_list_page.dart';
import 'package:bienes_raices_app/src/vistas/cliente/direcciones/mapa/cliente_direcciones_mapa_page.dart';
import 'package:bienes_raices_app/src/vistas/cliente/ordenes/crear/cliente_ordenes_crear_page.dart';
import 'package:bienes_raices_app/src/vistas/cliente/ordenes/detalle/cliente_ordenes_detalle_page.dart';
import 'package:bienes_raices_app/src/vistas/cliente/ordenes/list/cliente_ordenes_lista_page.dart';
import 'package:bienes_raices_app/src/vistas/cliente/ordenes/mapa/cliente_ordenes_mapa_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/agentes/registrar_nuevo_agente_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/categorias/crear/inmobiliaria_categoria_crear_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/estadisticas/inmobiliaria_estadiscas_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/ordenes/detalle/inmobiliaria_ordenes_detalle_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/ordenes/lista/inmobiliaria_ordernes_lista_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/productos/crear/inmobiliaria_productos_crear_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/productos/editar/Lista/inmobiliaria_productos_editar_lista_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/reportes/crear/inmobiliaria_reportes_crear_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/reportes/detalle_reporte/inmobiliaria_reportes_reporte_agente_detalle_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/reportes/reporte_agente/Lista/inmobiliaria_reportes_reporte_agente_page.dart';
import 'package:bienes_raices_app/src/vistas/inmobiliaria/reportes/reportes_generales/lista/inmobiliaria_reportes_lista_page.dart';
import 'package:bienes_raices_app/src/vistas/modificar_usuario/cliente_modificar_usuario_page.dart';
import 'package:bienes_raices_app/src/vistas/server_status/status_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServerStatusProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bienes Raices App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'roles': (BuildContext context) => RolesPage(),
          'cliente/ordenes/crear': (BuildContext context) =>
              ClienteOrdenesCrearPage(),
          'cliente/ordenes/detalle': (BuildContext context) =>
              ClienteOrdenesDetallePage(),
          'cliente/ordenes/list': (BuildContext context) =>
              ClienteOrdenesListPage(),
          'cliente/ordenes/mapa': (BuildContext context) =>
              ClienteOrdenesMapaPage(),
          'cliente/direcciones/crear': (BuildContext context) =>
              CLienteDireccionesCrearPage(),
          'cliente/direcciones/mapa': (BuildContext context) =>
              ClienteDireccionesMapaPage(),
          'cliente/direcciones/list': (BuildContext context) =>
              CLienteDireccionesListPage(),
          'cliente/propiedades/list': (BuildContext context) =>
              ClientePropiedadesList(),
          'cliente/modificar/usuario': (BuildContext context) =>
              ClienteModificarUsuarioPage(),
          'agente/gestiones/menu': (BuildContext context) =>
              AgenteGestionesMenuPage(),
          'agente/propiedades/list': (BuildContext context) =>
              AgenteGestionesListPage(),
          'agente/gestiones/mapa': (BuildContext context) =>
              AgenteGestionesMapaPage(),
          'agente/gestiones/reportes/lista': (BuildContext context) =>
              AgenteGestioneReportesListaPage(),
          'agente/gestiones/reportes/detalle': (BuildContext context) =>
              AgenteGestionesReportesDetallePage(),
          'inmobiliaria/estadisticas': (BuildContext context) =>
              InmobiliariaEstadicasPage(),
          'inmobiliaria/registrar/agente': (BuildContext context) =>
              InmobiliariaRegristrarNuevoAgentePage(),
          'inmobiliaria/reporte/crear': (BuildContext context) =>
              InmobiliariaReportesCrearPage(),
          'inmboliliaria/reporte/general/list': (BuildContext context) =>
              InmobiliariaReportesListaPage(),
          'inmobiliaria/propiedades/list': (BuildContext context) =>
              InmobiliariaGestionesListaPage(),
          'inmobiliaria/reporte/agente/list': (BuildContext context) =>
              InmobiliariaReportesAgenteListaPage(),
          'inmobiliaria/reporte/agente/detalle': (BuildContext context) =>
              InmobiliariaReportesAgenteDetallePage(),
          'inmobiliaria/ordenes/list': (BuildContext context) =>
              InmobiliariaOrdernesListPage(),
          'inmobiliaria/categoria/crear': (BuildContext context) =>
              InmobiliariaCategoriaCrearPage(),
          'inmobiliaria/producto/crear': (BuildContext context) =>
              InmobiliariaProductosCrearPage(),
          'inmobiliaria/producto/editar': (BuildContext context) =>
              InmobiliariaProductosEditarListaPage(),
          'inmobiliaria/ordenes/detalle': (BuildContext context) =>
              InmobiliariaOrdenesDetallePage(),
          'server/satus': (BuildContext context) => ServerStatusPage(),
        },
        theme: ThemeData(
            primaryColor: ColorsTheme.primaryColor,
            appBarTheme: AppBarTheme(elevation: 0)),
      ),
    );
  }
}
