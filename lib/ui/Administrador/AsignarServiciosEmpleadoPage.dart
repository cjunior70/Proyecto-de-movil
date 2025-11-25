import 'package:flutter/material.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/controllers/ServiciosController.dart';
import 'package:proyecto/controllers/EmpleadosController.dart';
import 'package:proyecto/controllers/InterServicioEmpleadoController.dart';

/// ✅ ASIGNAR SERVICIOS A EMPLEADO - CONECTADO A SUPABASE
class AsignarServiciosEmpleadoPage extends StatefulWidget {
  final Empleado empleado;
  final Empresa empresa;

  const AsignarServiciosEmpleadoPage({
    super.key,
    required this.empleado,
    required this.empresa,
  });

  @override
  State<AsignarServiciosEmpleadoPage> createState() =>
      _AsignarServiciosEmpleadoPageState();
}

class _AsignarServiciosEmpleadoPageState
    extends State<AsignarServiciosEmpleadoPage> {
  final ServicioController _servicioController = ServicioController();
  final InterServicioEmpleadoController _interController = 
      InterServicioEmpleadoController();

  bool _cargando = true;
  List<Servicio> _todosServicios = [];
  Set<String> _serviciosAsignados = {}; // IDs de servicios asignados
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
    });

    try {
      // ✅ 1. Cargar todos los servicios de la empresa
      final servicios = await _servicioController
          .obtenerTodasServiciosPorEmpresa(widget.empresa.Id ?? '');

      // ✅ 2. Obtener servicios ya asignados al empleado
      final serviciosAsignadosIds = await _interController
          .obtenerServiciosDeEmpleado(widget.empleado.Id ?? '');

      setState(() {
        _todosServicios = servicios;
        _serviciosAsignados = serviciosAsignadosIds;
        _cargando = false;
      });

      print('✅ Servicios cargados: ${servicios.length}');
      print('✅ Servicios asignados: ${serviciosAsignadosIds.length}');
    } catch (e) {
      print('❌ Error cargando datos: $e');
      setState(() {
        _cargando = false;
      });
      _mostrarSnackBar('Error al cargar datos', Colors.red);
    }
  }

  void _toggleServicio(String servicioId) {
    setState(() {
      if (_serviciosAsignados.contains(servicioId)) {
        _serviciosAsignados.remove(servicioId);
      } else {
        _serviciosAsignados.add(servicioId);
      }
    });
  }

  Future<void> _guardarAsignaciones() async {
    setState(() {
      _guardando = true;
    });

    try {
      // ✅ Guardar en la tabla de intersección
      final exito = await _interController.asignarServiciosAEmpleado(
        empleadoId: widget.empleado.Id ?? '',
        serviciosIds: _serviciosAsignados,
      );

      setState(() {
        _guardando = false;
      });

      if (exito) {
        _mostrarSnackBar(
          '✅ Servicios asignados correctamente',
          Colors.green,
        );

        // Volver atrás
        Navigator.pop(context, true);
      } else {
        _mostrarSnackBar('Error al guardar asignaciones', Colors.red);
      }
    } catch (e) {
      print('❌ Error guardando asignaciones: $e');
      setState(() {
        _guardando = false;
      });
      _mostrarSnackBar('Error al guardar asignaciones', Colors.red);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final nombreEmpleado = '${widget.empleado.PrimerNombre ?? ''} ${widget.empleado.PrimerApellido ?? ''}'.trim();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
              _buildHeader(nombreEmpleado),
              if (_cargando)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 240, 208, 48),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      _buildInfoEmpleado(nombreEmpleado),
                      _buildContadorServicios(),
                      Expanded(
                        child: _todosServicios.isEmpty
                            ? _buildEmptyState()
                            : _buildListaServicios(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _todosServicios.isNotEmpty
          ? _buildBottomBar()
          : null,
    );
  }

  Widget _buildHeader(String nombreEmpleado) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Asignar Servicios',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  nombreEmpleado,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoEmpleado(String nombreEmpleado) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color.fromARGB(255, 240, 208, 48),
            child: widget.empleado.Foto != null
                ? ClipOval(
                    child: Image.memory(
                      widget.empleado.Foto!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    widget.empleado.Sexo == 'Femenino'
                        ? Icons.woman_rounded
                        : Icons.man_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreEmpleado,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.empleado.Cargo ?? 'Profesional',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.empleado.Estado == 'Activo'
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.empleado.Estado ?? 'Sin estado',
                    style: TextStyle(
                      color: widget.empleado.Estado == 'Activo'
                          ? Colors.green
                          : Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContadorServicios() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 240, 208, 48).withOpacity(0.2),
            const Color.fromARGB(255, 255, 220, 100).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildContador(
            'Disponibles',
            '${_todosServicios.length}',
            Icons.room_service_rounded,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.2),
          ),
          _buildContador(
            'Asignados',
            '${_serviciosAsignados.length}',
            Icons.check_circle_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildContador(String label, String valor, IconData icono) {
    return Column(
      children: [
        Icon(
          icono,
          color: const Color.fromARGB(255, 240, 208, 48),
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildListaServicios() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _todosServicios.length,
      itemBuilder: (context, index) {
        final servicio = _todosServicios[index];
        final asignado = _serviciosAsignados.contains(servicio.Id);

        return _buildTarjetaServicio(servicio, asignado);
      },
    );
  }

  Widget _buildTarjetaServicio(Servicio servicio, bool asignado) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: asignado
              ? const Color.fromARGB(255, 240, 208, 48)
              : Colors.white.withOpacity(0.15),
          width: asignado ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: asignado
                ? const Color.fromARGB(255, 240, 208, 48).withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
            blurRadius: asignado ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _toggleServicio(servicio.Id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: asignado
                        ? const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 240, 208, 48),
                              Color.fromARGB(255, 255, 220, 100),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade600,
                              Colors.grey.shade800,
                            ],
                          ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    asignado ? Icons.check_circle : Icons.room_service_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        servicio.Nombre ?? 'Sin nombre',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (servicio.Descripcion != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          servicio.Descripcion!,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatearDuracion(servicio.TiempoPromedio),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '\$${servicio.Precio?.toStringAsFixed(0) ?? '0'}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 240, 208, 48),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (asignado)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 208, 48)
                          .withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color.fromARGB(255, 240, 208, 48),
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatearDuracion(Duration duracion) {
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60);

    if (horas > 0) {
      return '$horas h ${minutos > 0 ? "$minutos min" : ""}';
    }
    return '$minutos min';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.room_service_outlined,
              size: 80,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay servicios disponibles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Esta empresa aún no tiene servicios',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 35, 35, 35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: _guardando ? null : _guardarAsignaciones,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 208, 48),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: _guardando
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Guardar Asignaciones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${_serviciosAsignados.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}