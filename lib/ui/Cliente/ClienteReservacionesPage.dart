import 'package:flutter/material.dart';
import 'package:proyecto/models/Reservacion.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/controllers/ReservacionController.dart';
import 'package:proyecto/controllers/EmpleadosController.dart';
import 'package:proyecto/controllers/ServiciosController.dart';
import 'package:proyecto/controllers/InterReservacionEmpleadoServicioController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClienteReservacionesPage extends StatefulWidget {
  const ClienteReservacionesPage({super.key});

  @override
  State<ClienteReservacionesPage> createState() => _ClienteReservacionesPageState();
}

class _ClienteReservacionesPageState extends State<ClienteReservacionesPage> {
  final ReservacionController _reservacionController = ReservacionController();
  final InterReservacionEmpleadoServicioController _interController = 
      InterReservacionEmpleadoServicioController();
  final EmpleadoController _empleadoController = EmpleadoController();
  final ServicioController _servicioController = ServicioController();

  bool _cargando = true;
  List<Map<String, dynamic>> _reservacionesCompletas = [];
  String? _clienteId;

  @override
  void initState() {
    super.initState();
    _cargarReservaciones();
  }

  Future<void> _cargarReservaciones() async {
    setState(() => _cargando = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      _clienteId = prefs.getString('uid');

      if (_clienteId == null) {
        print('❌ No hay cliente logueado');
        setState(() => _cargando = false);
        return;
      }

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📱 INICIANDO CARGA DE RESERVACIONES');
      print('   Cliente ID: $_clienteId');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      // ✅ 1. Cargar reservaciones base
      final reservaciones = await _reservacionController
          .obtenerReservacionesPorCliente(_clienteId!);

      print('✅ ${reservaciones.length} reservaciones encontradas');

      // ✅ 2. Para cada reservación, obtener empleados y servicios
      List<Map<String, dynamic>> reservacionesCompletas = [];

      for (var i = 0; i < reservaciones.length; i++) {
        final reservacion = reservaciones[i];
        print('\n🔍 Procesando reservación ${i + 1}/${reservaciones.length}');
        print('   ID: ${reservacion.Id}');
        print('   Fecha: ${reservacion.Fecha}');
        print('   Total: \$${reservacion.Total}');

        // Obtener relaciones de la tabla de intersección
        final relaciones = await _interController
            .obtenerRelacionesPorReservacion(reservacion.Id ?? '');

        print('   🔗 Relaciones encontradas: ${relaciones.length} empleados');
        print('   Detalles: $relaciones');

        List<Empleado> empleados = [];
        List<Servicio> servicios = [];

        if (relaciones.isEmpty) {
          print('   ⚠️ NO HAY RELACIONES - La reservación no tiene empleados/servicios asignados');
        } else {
          // ✅ Cargar datos completos de empleados y servicios
          for (var empleadoId in relaciones.keys) {
            print('   🔄 Cargando empleado: $empleadoId');
            
            try {
              final empleado = await _empleadoController.obtenerEmpleado(empleadoId);
              if (empleado != null) {
                empleados.add(empleado);
                print('   ✅ Empleado cargado: ${empleado.PrimerNombre} ${empleado.PrimerApellido}');
              } else {
                print('   ❌ Empleado $empleadoId no encontrado en BD');
              }

              // Cargar servicios de este empleado
              final serviciosIds = relaciones[empleadoId]!;
              print('   🔄 Cargando ${serviciosIds.length} servicios del empleado');
              
              for (var servicioId in serviciosIds) {
                try {
                  final servicio = await _servicioController.obtenerServicio(servicioId);
                  if (servicio != null) {
                    // Evitar duplicados
                    if (!servicios.any((s) => s.Id == servicio.Id)) {
                      servicios.add(servicio);
                      print('   ✅ Servicio cargado: ${servicio.Nombre} (\$${servicio.Precio})');
                    } else {
                      print('   ⏭️ Servicio ${servicio.Nombre} ya agregado (evitando duplicado)');
                    }
                  } else {
                    print('   ❌ Servicio $servicioId no encontrado en BD');
                  }
                } catch (e) {
                  print('   ❌ Error cargando servicio $servicioId: $e');
                }
              }
            } catch (e) {
              print('   ❌ Error cargando empleado $empleadoId: $e');
            }
          }
        }

        print('   📊 Resumen:');
        print('      - Empleados: ${empleados.length}');
        print('      - Servicios: ${servicios.length}');

        reservacionesCompletas.add({
          'reservacion': reservacion,
          'empleados': empleados,
          'servicios': servicios,
        });
      }

      setState(() {
        _reservacionesCompletas = reservacionesCompletas;
        _cargando = false;
      });

      print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('✅ CARGA COMPLETA: ${reservacionesCompletas.length} reservaciones procesadas');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    } catch (e) {
      print('❌ ERROR CRÍTICO en _cargarReservaciones: $e');
      print('   Stack trace: ${StackTrace.current}');
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 35, 35),
        title: const Text(
          'Mis Reservaciones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarReservaciones,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 240, 208, 48),
              ),
            )
          : _reservacionesCompletas.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  color: const Color.fromARGB(255, 240, 208, 48),
                  onRefresh: _cargarReservaciones,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _reservacionesCompletas.length,
                    itemBuilder: (context, index) {
                      return _buildTarjetaReservacion(_reservacionesCompletas[index]);
                    },
                  ),
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
            child: const Icon(Icons.calendar_today, size: 80, color: Colors.white38),
          ),
          const SizedBox(height: 24),
          const Text(
            'No tienes reservaciones',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tus reservaciones aparecerán aquí',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaReservacion(Map<String, dynamic> data) {
    final Reservacion reservacion = data['reservacion'];
    final List<Empleado> empleados = data['empleados'];
    final List<Servicio> servicios = data['servicios'];

    final esProxima = reservacion.Fecha != null && 
                      reservacion.Fecha!.isAfter(DateTime.now());
    final colorEstado = _getColorEstado(reservacion.Estado ?? 'Pendiente');

    // ✅ DEBUGGING: Mostrar en consola lo que se va a renderizar
    print('📱 Renderizando tarjeta:');
    print('   - Reservación: ${reservacion.Id}');
    print('   - Empleados para mostrar: ${empleados.length}');
    print('   - Servicios para mostrar: ${servicios.length}');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: esProxima 
              ? const Color.fromARGB(255, 240, 208, 48).withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: esProxima ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _mostrarDetalles(reservacion, empleados, servicios),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado con estado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorEstado.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorEstado),
                      ),
                      child: Text(
                        reservacion.Estado ?? 'Pendiente',
                        style: TextStyle(
                          color: colorEstado,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (esProxima)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 240, 208, 48),
                              Color.fromARGB(255, 255, 220, 100),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'PRÓXIMA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Fecha y hora
                if (reservacion.Fecha != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color.fromARGB(255, 240, 208, 48), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _formatearFecha(reservacion.Fecha!),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, color: Colors.white60, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        _formatearHora(reservacion.Fecha!),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                const Divider(color: Colors.white24),
                const SizedBox(height: 12),

                // ✅ SERVICIOS - Mostrar siempre, incluso si está vacío
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.content_cut, color: Colors.white60, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Servicio:',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          if (servicios.isEmpty)
                            const Text(
                              'Sin servicio asignado',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          else
                            ...servicios.map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${s.Nombre} - \$${s.Precio?.toStringAsFixed(0) ?? '0'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ✅ EMPLEADOS - Mostrar siempre, incluso si está vacío
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person, color: Colors.white60, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profesional:',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          if (empleados.isEmpty)
                            const Text(
                              'Sin profesional asignado',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          else
                            ...empleados.map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${e.PrimerNombre ?? ''} ${e.PrimerApellido ?? ''} - ${e.Cargo ?? 'Profesional'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Total
                if (reservacion.Total != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          '\$${reservacion.Total!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 240, 208, 48),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Calificación
                if (reservacion.Estrellas != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < reservacion.Estrellas!.round() ? Icons.star : Icons.star_border,
                          color: const Color.fromARGB(255, 240, 208, 48),
                          size: 18,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${reservacion.Estrellas!.toStringAsFixed(1)}',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'confirmada': return Colors.green;
      case 'pendiente': return const Color.fromARGB(255, 240, 208, 48);
      case 'cancelada': return Colors.red;
      case 'completada': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String _formatearFecha(DateTime fecha) {
    final dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${dias[fecha.weekday - 1]}, ${fecha.day} ${meses[fecha.month - 1]}';
  }

  String _formatearHora(DateTime fecha) {
    final hora = fecha.hour > 12 ? fecha.hour - 12 : (fecha.hour == 0 ? 12 : fecha.hour);
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final periodo = fecha.hour >= 12 ? 'PM' : 'AM';
    return '$hora:$minutos $periodo';
  }

  void _mostrarDetalles(Reservacion reservacion, List<Empleado> empleados, List<Servicio> servicios) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 240, 208, 48),
                          Color.fromARGB(255, 255, 220, 100),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info_outline, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Detalles de la Reservación',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Servicios
              const Text('Servicios:', style: TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (servicios.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No hay servicios asignados a esta reservación',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...servicios.map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color.fromARGB(255, 240, 208, 48), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.Nombre ?? 'Servicio',
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            if (s.Descripcion != null)
                              Text(
                                s.Descripcion!,
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${s.Precio?.toStringAsFixed(0) ?? '0'}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 240, 208, 48),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )),
              const SizedBox(height: 16),
              
              // Empleados
              const Text('Profesionales:', style: TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (empleados.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No hay profesionales asignados a esta reservación',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...empleados.map((e) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                        child: e.Foto != null
                            ? ClipOval(child: Image.memory(e.Foto!, width: 48, height: 48, fit: BoxFit.cover))
                            : Icon(
                                e.Sexo == 'Femenino' ? Icons.woman_rounded : Icons.man_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${e.PrimerNombre ?? ''} ${e.PrimerApellido ?? ''}'.trim(),
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              e.Cargo ?? 'Profesional',
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

              if (reservacion.Comentario != null) ...[
                const SizedBox(height: 16),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
                const Text('Notas:', style: TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  reservacion.Comentario!,
                  style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                ),
              ],
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cerrar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}