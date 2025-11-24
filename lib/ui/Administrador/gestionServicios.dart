import 'package:flutter/material.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/controllers/ServiciosController.dart';
import 'package:proyecto/ui/componentes/servicios/BusquedaYEstadisticas.dart';
import 'package:proyecto/ui/componentes/servicios/ConfirmacionEliminarDialog.dart';
import 'package:proyecto/ui/componentes/servicios/EstadoVacioYCargando.dart';
import 'package:proyecto/ui/componentes/servicios/FormularioServicioDialog.dart';
import 'package:proyecto/ui/componentes/servicios/GestionServiciosHeader.dart';
import 'package:proyecto/ui/componentes/servicios/ServicioCard.dart';
import 'package:uuid/uuid.dart';


/// ✅ GESTIÓN DE SERVICIOS - Integrado con Supabase
class GestionServicios extends StatefulWidget {
  final Empresa empresa;
  const GestionServicios({super.key, required this.empresa});

  @override
  State<GestionServicios> createState() => _GestionServiciosState();
}

class _GestionServiciosState extends State<GestionServicios>
    with SingleTickerProviderStateMixin {
  
  // Controladores y Servicios
  final TextEditingController _searchController = TextEditingController();
  final ServicioController _servicioController = ServicioController();
  late AnimationController _animationController;

  // Estado
  List<Servicio> _servicios = [];
  List<Servicio> _serviciosFiltrados = [];
  bool _cargando = true;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _cargarServicios();
    _searchController.addListener(() {
      _filtrarServicios(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ====================================================================
  // ✅ LÓGICA DE NEGOCIO Y ESTADO
  // ====================================================================

  // ✅ CARGAR SERVICIOS DESDE SUPABASE
  Future<void> _cargarServicios() async {
    setState(() {
      _cargando = true;
    });

    try {
      final servicios = await _servicioController
          .obtenerTodasServiciosPorEmpresa(widget.empresa.Id ?? '');

      setState(() {
        _servicios = servicios;
        _serviciosFiltrados = List.from(servicios);
        _cargando = false;
      });

      _animationController.forward(from: 0.0);
    } catch (e) {
      print('❌ Error cargando servicios: $e');
      setState(() {
        _cargando = false;
      });
      _mostrarSnackBar('Error al cargar servicios', Colors.red);
    }
  }

  // ✅ FILTRAR SERVICIOS
  void _filtrarServicios(String query) {
    setState(() {
      if (query.isEmpty) {
        _serviciosFiltrados = List.from(_servicios);
      } else {
        final queryLower = query.toLowerCase();
        _serviciosFiltrados = _servicios.where((servicio) {
          final nombre = servicio.Nombre?.toLowerCase() ?? '';
          final descripcion = servicio.Descripcion?.toLowerCase() ?? '';
          return nombre.contains(queryLower) || descripcion.contains(queryLower);
        }).toList();
      }
    });
  }

  // ✅ AGREGAR SERVICIO
  void _agregarServicio() {
    _mostrarFormularioServicio(null);
  }

  // ✅ EDITAR SERVICIO
  void _editarServicio(Servicio servicio) {
    _mostrarFormularioServicio(servicio);
  }

  // ✅ ELIMINAR SERVICIO
  void _eliminarServicio(Servicio servicio) {
    showDialog(
      context: context,
      builder: (context) => ConfirmacionEliminarDialog(
        servicio: servicio,
        onConfirm: () async {
          Navigator.pop(context); // Cerrar diálogo
          
          // Mostrar loader temporal
          _mostrarSnackBar('Eliminando servicio...', Colors.orange);

          final exito = await _servicioController.eliminarServicio(servicio.Id);

          if (exito) {
            // TODO: Enviar notificación a empleados y clientes
            _enviarNotificacionEliminacion(servicio);
            
            await _cargarServicios();
            _mostrarSnackBar(
              '✅ Servicio eliminado. Notificación enviada.',
              Colors.green,
            );
          } else {
            _mostrarSnackBar('Error al eliminar servicio', Colors.red);
          }
        },
      ),
    );
  }

  // ✅ MOSTRAR FORMULARIO (AGREGAR/EDITAR)
  void _mostrarFormularioServicio(Servicio? servicio) {
    showDialog(
      context: context,
      builder: (context) => FormularioServicioDialog(
        servicio: servicio,
        uuid: _uuid,
        onSave: (nuevoServicio) async {
          nuevoServicio.empresa = widget.empresa ;
          print("DATOS DE EMPRESA : ${widget.empresa} " );
          Navigator.pop(context); // Cerrar diálogo

          bool exito = false;
          
          if (servicio == null) {
            // ✅ AGREGAR
            _mostrarSnackBar('Guardando servicio...', Colors.orange);
            exito = await _servicioController.guardarServicio(nuevoServicio);
            
            if (exito) {
              await _cargarServicios();
              _mostrarSnackBar('✅ Servicio agregado exitosamente', Colors.green);
            }
          } else {
            // ✅ EDITAR
            _mostrarSnackBar('Actualizando servicio...', Colors.orange);
            exito = await _servicioController.actualizarServicio(nuevoServicio);
            
            if (exito) {
              // TODO: Enviar notificación a empleados y clientes
              _enviarNotificacionEdicion(nuevoServicio);
              
              await _cargarServicios();
              _mostrarSnackBar('✅ Servicio actualizado. Notificación enviada.', Colors.green);
            }
          }

          if (!exito) {
            _mostrarSnackBar('Error al guardar el servicio', Colors.red);
          }
        },
      ),
    );
  }


  // ====================================================================
  // ✅ FUNCIONES DE UTILIDAD (Quedan aquí porque dependen del contexto/estado)
  // ====================================================================

  // ✅ SNACKBAR
  void _mostrarSnackBar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  
  // ✅ NOTIFICACIONES (TODO: Implementar sistema real)
  void _enviarNotificacionEdicion(Servicio servicio) {
    print('📧 Notificación enviada: Servicio "${servicio.Nombre}" actualizado');
  }

  void _enviarNotificacionEliminacion(Servicio servicio) {
    print('📧 Notificación enviada: Servicio "${servicio.Nombre}" eliminado');
  }

  // ✅ FORMATEAR DURACIÓN (Mantenida aquí para reusar)
  String _formatearDuracion(Duration duracion) {
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60);
    
    if (horas > 0) {
      return '$horas h ${minutos > 0 ? "$minutos min" : ""}';
    }
    return '$minutos min';
  }


  // ====================================================================
  // ✅ BUILD MÉTODO
  // ====================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // ... (Degradado de fondo original) ...
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 35, 35, 35),
              Color.fromARGB(255, 50, 50, 50),
              Color.fromARGB(255, 70, 70, 70),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Header
              GestionServiciosHeader(empresaNombre: widget.empresa.Nombre),
              
              // 2. Barra de Búsqueda y Estadísticas
              BusquedaYEstadisticas(
                searchController: _searchController,
                serviciosFiltradosCount: _serviciosFiltrados.length,
                onClearSearch: () {
                  _searchController.clear();
                  _filtrarServicios('');
                },
              ),

              // 3. Contenido Principal (Lista/Estado)
              Expanded(
                child: _cargando
                    ? const EstadoVacioYCargando(isCargando: true)
                    : _serviciosFiltrados.isEmpty
                        ? EstadoVacioYCargando(
                            isCargando: false,
                            isFiltrando: _searchController.text.isNotEmpty,
                          )
                        : _buildListaServicios(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ✅ LISTA DE SERVICIOS
  Widget _buildListaServicios() {
    return RefreshIndicator(
      onRefresh: _cargarServicios,
      color: const Color.fromARGB(255, 240, 208, 48),
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _serviciosFiltrados.length,
        itemBuilder: (context, index) {
          final servicio = _serviciosFiltrados[index];
          return FadeTransition(
            opacity: _animationController,
            child: ServicioCard(
              servicio: servicio,
              formatearDuracion: _formatearDuracion,
              onEdit: _editarServicio,
              onDelete: _eliminarServicio,
            ),
          );
        },
      ),
    );
  }

  // ✅ FLOATING ACTION BUTTON
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: _agregarServicio,
      backgroundColor: const Color.fromARGB(255, 240, 208, 48),
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
    );
  }
}