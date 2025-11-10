import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// ✅ PÁGINA PARA CREAR RESERVACIÓN
class ReservaPage extends StatefulWidget {
  final String? empresaId;
  final Map<String, dynamic> empresa;
  final Map<String, dynamic> servicio;
  final Map<String, dynamic> empleado;

  const ReservaPage({
    super.key,
    this.empresaId,
    required this.empresa,
    required this.servicio,
    required this.empleado,
  });

  @override
  State<ReservaPage> createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  DateTime _fechaSeleccionada = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _horaSeleccionada;
  bool _cargandoHorarios = false;

  // ✅ HORARIOS DISPONIBLES (Tu compañero los traerá de la API)
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
    _cargarHorariosDisponibles();
  }

  void _cargarHorariosDisponibles() async {
    setState(() {
      _cargandoHorarios = true;
    });

    // ✅ Tu compañero implementará:
    // final horarios = await ReservaService.obtenerHorariosDisponibles(
    //   empresaId: widget.empresaId,
    //   empleadoId: widget.empleado['id'],
    //   fecha: _fechaSeleccionada,
    // );

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
        _horaSeleccionada = null; // Resetear hora al cambiar fecha
      });
      _cargarHorariosDisponibles();
    }
  }

  void _confirmarReserva() {
    if (_horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Selecciona una hora para continuar'),
          backgroundColor: const Color.fromARGB(255, 240, 208, 48),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // ✅ Mostrar confirmación
    _mostrarDialogoConfirmacion();
  }

  void _mostrarDialogoConfirmacion() {
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
                _buildResumenItem('Servicio', widget.servicio['nombre']),
                _buildResumenItem('Profesional', widget.empleado['nombre']),
                _buildResumenItem(
                  'Fecha',
                  '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                ),
                _buildResumenItem('Hora', _horaSeleccionada!),
                _buildResumenItem('Duración', widget.servicio['duracion']),
                _buildResumenItem('Total', '\$${widget.servicio['precio']}'),
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
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _procesarReserva() async {
    // ✅ Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 240, 208, 48),
        ),
      ),
    );

    // ✅ Tu compañero implementará:
    // await ReservaService.crearReserva(
    //   empresaId: widget.empresaId,
    //   servicioId: widget.servicio['id'],
    //   empleadoId: widget.empleado['id'],
    //   fecha: _fechaSeleccionada,
    //   hora: _horaSeleccionada,
    // );

    await Future.delayed(const Duration(seconds: 2));

    Navigator.pop(context); // Cerrar loading

    // ✅ Mostrar éxito y volver al home
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ ¡Reserva confirmada exitosamente!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Volver al inicio (eliminar todas las rutas)
    Navigator.of(context).popUntil((route) => route.isFirst);
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
                  widget.servicio['icono'],
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
                      widget.servicio['nombre'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${widget.servicio['precio']} • ${widget.servicio['duracion']}',
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
                backgroundImage: NetworkImage(widget.empleado['foto']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.empleado['nombre'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.empleado['especialidad'],
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
                  '\$${widget.servicio['precio']}',
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