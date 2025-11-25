import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:proyecto/models/Reservacion.dart';
import 'package:proyecto/models/Cliente.dart';
import 'package:proyecto/models/Contabilidad.dart';
import 'package:proyecto/controllers/ReservacionController.dart';
import 'package:proyecto/controllers/ContabilidadController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// ✅ CREAR RESERVACIÓN - Integrado con Supabase
class ReservaPage extends StatefulWidget {
  final Empresa empresa;
  final Servicio servicio;
  final Empleado empleado;

  const ReservaPage({
    super.key,
    required this.empresa,
    required this.servicio,
    required this.empleado,
  });

  @override
  State<ReservaPage> createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  final ReservacionController _reservacionController = ReservacionController();
  final ContabilidadController _contabilidadController = ContabilidadController();
  final _uuid = const Uuid();

  DateTime _fechaSeleccionada = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _horaSeleccionada;
  bool _cargandoHorarios = false;
  String? _clienteId;

  // ✅ HORARIOS DISPONIBLES (Simulados - puedes cargarlos de Supabase)
  final List<String> _horariosDisponibles = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _cargarClienteId();
    _cargarHorariosDisponibles();
  }

  // ✅ Obtener ID del cliente desde SharedPreferences
  Future<void> _cargarClienteId() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    
    if (uid == null) {
      //print('❌ Error: No hay cliente logueado');
      _mostrarError('Debes iniciar sesión para reservar');
      Navigator.pop(context);
      return;
    }

    setState(() {
      _clienteId = uid;
    });
    
    //print('✅ Cliente ID cargado: $_clienteId');
  }

  void _cargarHorariosDisponibles() async {
    setState(() {
      _cargandoHorarios = true;
    });

    // TODO: Implementar carga de horarios desde Supabase
    // Filtrar horarios ya reservados para esta fecha y empleado
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _cargandoHorarios = false;
    });
  }

  void _onDiaSeleccionado(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_fechaSeleccionada, selectedDay)) {
      setState(() {
        _fechaSeleccionada = selectedDay;
        _focusedDay = focusedDay;
        _horaSeleccionada = null;
      });
      _cargarHorariosDisponibles();
    }
  }

  void _confirmarReserva() {
    if (_horaSeleccionada == null) {
      _mostrarSnackBar('⚠️ Selecciona una hora para continuar', Colors.orange);
      return;
    }

    if (_clienteId == null) {
      _mostrarError('Error: Cliente no identificado');
      return;
    }

    _mostrarDialogoConfirmacion();
  }

  void _mostrarDialogoConfirmacion() {
    final nombreEmpleado = '${widget.empleado.PrimerNombre ?? ''} ${widget.empleado.PrimerApellido ?? ''}'.trim();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 35, 35, 35),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 240, 208, 48),
                        Color.fromARGB(255, 255, 220, 100),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '¿Confirmar Reserva?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildResumenItem('Empresa', widget.empresa.Nombre ?? 'N/A'),
                _buildResumenItem('Servicio', widget.servicio.Nombre ?? 'N/A'),
                _buildResumenItem('Profesional', nombreEmpleado),
                _buildResumenItem(
                  'Fecha',
                  '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                ),
                _buildResumenItem('Hora', _horaSeleccionada!),
                _buildResumenItem(
                  'Duración',
                  _formatearDuracion(widget.servicio.TiempoPromedio),
                ),
                _buildResumenItem(
                  'Total',
                  '\$${widget.servicio.Precio?.toStringAsFixed(0) ?? '0'}',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _procesarReserva();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResumenItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _procesarReserva() async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 240, 208, 48),
        ),
      ),
    );

    try {
      // ✅ Combinar fecha y hora
      final fechaHora = _combinarFechaHora(_fechaSeleccionada, _horaSeleccionada!);
      
      //print('🔍 Datos de reservación:');
      //print('  - Cliente ID: $_clienteId');
      //print('  - Empresa ID: ${widget.empresa.Id}');
      //print('  - Servicio: ${widget.servicio.Nombre}');
      //print('  - Empleado: ${widget.empleado.PrimerNombre} ${widget.empleado.PrimerApellido}');
      //print('  - Fecha/Hora: $fechaHora');
      //print('  - Total: ${widget.servicio.Precio}');

      // ✅ 1. Obtener contabilidad de la empresa
      final contabilidades = await _contabilidadController
          .obtenerContabilidadesPorEmpresa(widget.empresa.Id ?? '');
      
      Contabilidad? contabilidad;
      if (contabilidades.isNotEmpty) {
        contabilidad = contabilidades.first as Contabilidad?;
        //print('✅ Contabilidad encontrada: ${contabilidad?.Id ?? "sin ID"}');
      } else {
        //print('⚠️ No se encontró contabilidad para la empresa');
      }

      // ✅ 2. Crear la reservación
      final nuevaReservacion = Reservacion(
        Id: _uuid.v4(),
        Creacion: DateTime.now(),
        Fecha: fechaHora,
        Total: widget.servicio.Precio ?? 0.0,
        Estado: 'Pendiente',
        Comentario: 'Reserva realizada desde la app',
        Estrellas: null, // Se califica después
        empresa: Empresa(Id: widget.empresa.Id),
        cliente: Cliente(Id: _clienteId),
        contabilidad: contabilidad != null ? Contabilidad(Id: contabilidad.Id) : null,
      );

      //print('📝 JSON a enviar: ${nuevaReservacion.toJson()}');

      // ✅ 3. Guardar en Supabase
      final exito = await _reservacionController.guardarReservacion(nuevaReservacion);

      Navigator.pop(context); // Cerrar loading

      if (exito) {
        //print('✅ Reservación guardada exitosamente');
        
        // Mostrar éxito
        _mostrarSnackBar('✅ ¡Reserva confirmada exitosamente!', Colors.green);
        
        // Volver al inicio
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        //print('❌ Error al guardar reservación');
        _mostrarError('No se pudo crear la reservación. Intenta de nuevo.');
      }
    } catch (e) {
      //print('❌ Error procesando reserva: $e');
      Navigator.pop(context); // Cerrar loading
      _mostrarError('Error: $e');
    }
  }

  DateTime _combinarFechaHora(DateTime fecha, String hora) {
    // Convertir "09:00 AM" a horas y minutos
    final partes = hora.split(' ');
    final tiempo = partes[0].split(':');
    int horas = int.parse(tiempo[0]);
    final minutos = int.parse(tiempo[1]);
    
    // Ajustar para formato 12h
    if (partes[1] == 'PM' && horas != 12) {
      horas += 12;
    } else if (partes[1] == 'AM' && horas == 12) {
      horas = 0;
    }

    return DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      horas,
      minutos,
    );
  }

  void _mostrarSnackBar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 35, 35, 35),
        title: const Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(mensaje, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color.fromARGB(255, 240, 208, 48)),
            ),
          ),
        ],
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResumenReserva(),
                      const SizedBox(height: 24),
                      _buildCalendario(),
                      const SizedBox(height: 24),
                      _buildSeleccionHora(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nueva Reserva',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Selecciona fecha y hora',
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

  Widget _buildResumenReserva() {
    final nombreEmpleado = '${widget.empleado.PrimerNombre ?? ''} ${widget.empleado.PrimerApellido ?? ''}'.trim();
    
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      widget.servicio.Nombre ?? 'Servicio',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${widget.servicio.Precio?.toStringAsFixed(0) ?? '0'} • ${_formatearDuracion(widget.servicio.TiempoPromedio)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                child: widget.empleado.Foto != null
                    ? ClipOval(
                        child: Image.memory(
                          widget.empleado.Foto!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        widget.empleado.Sexo == 'Femenino'
                            ? Icons.woman_rounded
                            : Icons.man_rounded,
                        color: Colors.white,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombreEmpleado,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.empleado.Cargo ?? 'Profesional',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendario() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 90)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_fechaSeleccionada, day),
        onDaySelected: _onDiaSeleccionado,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: Color.fromARGB(255, 240, 208, 48),
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Color.fromARGB(255, 240, 208, 48),
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white70),
          weekendStyle: TextStyle(color: Colors.white70),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(color: Colors.white70),
          weekendTextStyle: const TextStyle(color: Colors.white70),
          outsideTextStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          selectedDecoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 240, 208, 48),
                Color.fromARGB(255, 255, 220, 100),
              ],
            ),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSeleccionHora() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona la Hora',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        if (_cargandoHorarios)
          const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 240, 208, 48),
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _horariosDisponibles.map((hora) {
              final seleccionada = _horaSeleccionada == hora;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _horaSeleccionada = hora;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: seleccionada
                        ? const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 240, 208, 48),
                              Color.fromARGB(255, 255, 220, 100),
                            ],
                          )
                        : null,
                    color: seleccionada ? null : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: seleccionada
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.2),
                      width: seleccionada ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    hora,
                    style: TextStyle(
                      color: seleccionada ? Colors.white : Colors.white70,
                      fontWeight:
                          seleccionada ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total a pagar:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${widget.servicio.Precio?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 240, 208, 48),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _confirmarReserva,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Confirmar Reserva',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check_circle, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}