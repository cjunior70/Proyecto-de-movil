import 'package:flutter/material.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:proyecto/controllers/EmpleadosController.dart';
import 'package:proyecto/controllers/InterServicioEmpleadoController.dart';
import 'reservarservicio.dart';

/// ✅ SELECCIÓN DE EMPLEADOS - FILTRADO POR SERVICIO
class ServicioEmpleadosPage extends StatefulWidget {
  final Empresa empresa;
  final Servicio servicio;

  const ServicioEmpleadosPage({
    super.key,
    required this.empresa,
    required this.servicio,
  });

  @override
  State<ServicioEmpleadosPage> createState() => _ServicioEmpleadosPageState();
}

class _ServicioEmpleadosPageState extends State<ServicioEmpleadosPage> {
  final EmpleadoController _empleadoController = EmpleadoController();
  final InterServicioEmpleadoController _interController = 
      InterServicioEmpleadoController();
  
  bool _cargando = true;
  List<Empleado> _empleados = [];
  String? _empleadoSeleccionadoId;

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  Future<void> _cargarEmpleados() async {
    setState(() {
      _cargando = true;
    });

    try {
      // ✅ 1. Obtener IDs de empleados que tienen este servicio asignado
      final empleadosIdsConServicio = await _interController
          .obtenerEmpleadosDeServicio(widget.servicio.Id);

      print('👥 Empleados con el servicio ${widget.servicio.Nombre}: ${empleadosIdsConServicio.length}');

      if (empleadosIdsConServicio.isEmpty) {
        setState(() {
          _empleados = [];
          _cargando = false;
        });
        return;
      }

      // ✅ 2. Cargar todos los empleados de la empresa
      final todosLosEmpleados = await _empleadoController
          .obtenerEmpleadosPorEmpresa(widget.empresa.Id ?? '');

      // ✅ 3. Filtrar solo empleados activos que tengan este servicio
      final empleadosFiltrados = todosLosEmpleados.where((empleado) {
        final tieneServicio = empleadosIdsConServicio.contains(empleado.Id);
        final estaActivo = empleado.Estado == 'Activo';
        return tieneServicio && estaActivo;
      }).toList();

      setState(() {
        _empleados = empleadosFiltrados;
        _cargando = false;
      });

      print('✅ ${empleadosFiltrados.length} empleados cargados con el servicio');

    } catch (e) {
      print('❌ Error cargando empleados: $e');
      setState(() {
        _cargando = false;
      });
    }
  }

  void _seleccionarEmpleado(String empleadoId) {
    setState(() {
      _empleadoSeleccionadoId = empleadoId;
    });
  }

  void _continuarConReserva() {
    if (_empleadoSeleccionadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Selecciona un profesional para continuar'),
          backgroundColor: const Color.fromARGB(255, 240, 208, 48),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final empleado = _empleados.firstWhere((e) => e.Id == _empleadoSeleccionadoId);

    // ✅ NAVEGAR A PÁGINA DE RESERVA CON DATOS REALES
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservaPage(
          empresa: widget.empresa,
          servicio: widget.servicio,
          empleado: empleado,
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

  IconData _obtenerIconoServicio(String nombre) {
    final nombreLower = nombre.toLowerCase();
    
    if (nombreLower.contains('corte') || nombreLower.contains('cabello')) {
      return Icons.content_cut;
    } else if (nombreLower.contains('barba') || nombreLower.contains('bigote')) {
      return Icons.face;
    } else if (nombreLower.contains('color') || nombreLower.contains('tinte')) {
      return Icons.brush;
    } else if (nombreLower.contains('premium') || nombreLower.contains('vip')) {
      return Icons.star;
    }
    
    return Icons.miscellaneous_services;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 43, 43, 43),
              Color.fromARGB(255, 80, 80, 80),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(),
              Expanded(
                child: _cargando ? _buildCargando() : _buildContenido(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _empleados.isNotEmpty ? _buildBottomBar() : null,
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
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
                Text(
                  widget.servicio.Nombre ?? 'Servicio',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Selecciona tu profesional',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCargando() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color.fromARGB(255, 240, 208, 48),
      ),
    );
  }

  Widget _buildContenido() {
    if (_empleados.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoServicio(),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                "Profesionales Disponibles",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 240, 208, 48),
                  ),
                ),
                child: Text(
                  '${_empleados.length}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 240, 208, 48),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _empleados.length,
            itemBuilder: (context, index) {
              final empleado = _empleados[index];
              return _buildTarjetaEmpleado(empleado);
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
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
              Icons.people_outline,
              size: 80,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay profesionales disponibles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No hay empleados activos con este servicio asignado',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '💡 Tip: El administrador debe asignar\neste servicio a los empleados',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoServicio() {
    return Container(
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
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 240, 208, 48),
                  Color.fromARGB(255, 255, 220, 100),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _obtenerIconoServicio(widget.servicio.Nombre ?? ''),
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.servicio.Nombre ?? 'Sin nombre',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.white60),
                    const SizedBox(width: 4),
                    Text(
                      _formatearDuracion(widget.servicio.TiempoPromedio),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '\$${widget.servicio.Precio?.toStringAsFixed(0) ?? '0'}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 240, 208, 48),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaEmpleado(Empleado empleado) {
    final bool seleccionado = _empleadoSeleccionadoId == empleado.Id;
    final nombreCompleto = '${empleado.PrimerNombre ?? ''} ${empleado.PrimerApellido ?? ''}'.trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: seleccionado
              ? const Color.fromARGB(255, 240, 208, 48)
              : Colors.white.withOpacity(0.1),
          width: seleccionado ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: seleccionado
                ? const Color.fromARGB(255, 240, 208, 48).withOpacity(0.3)
                : Colors.black.withOpacity(0.3),
            blurRadius: seleccionado ? 15 : 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _seleccionarEmpleado(empleado.Id ?? ''),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: seleccionado
                              ? const Color.fromARGB(255, 240, 208, 48)
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                        child: empleado.Foto != null
                            ? ClipOval(
                                child: Image.memory(
                                  empleado.Foto!,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                empleado.Sexo == 'Femenino'
                                    ? Icons.woman_rounded
                                    : Icons.man_rounded,
                                color: Colors.white,
                                size: 35,
                              ),
                      ),
                    ),
                    if (seleccionado)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 240, 208, 48),
                                Color.fromARGB(255, 255, 220, 100),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreCompleto,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        empleado.Cargo ?? 'Profesional',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                      if (empleado.FechaDeInicio != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.work_outline,
                                size: 14, color: Colors.white38),
                            const SizedBox(width: 4),
                            Text(
                              _calcularExperiencia(empleado.FechaDeInicio!),
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _calcularExperiencia(DateTime fechaInicio) {
    final diferencia = DateTime.now().difference(fechaInicio);
    final year = (diferencia.inDays / 365).floor();
    final meses = ((diferencia.inDays % 365) / 30).floor();

    if (year > 0) {
      return '$year año${year > 1 ? 's' : ''} de experiencia';
    } else if (meses > 0) {
      return '$meses mes${meses > 1 ? 'es' : ''} de experiencia';
    }
    return 'Recién ingresado';
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
            onPressed: _continuarConReserva,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 208, 48),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Continuar con la Reserva",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}