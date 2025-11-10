import 'package:flutter/material.dart';

/// ✅ PÁGINA DE RESERVACIONES DEL CLIENTE
class ClienteReservacionesPage extends StatefulWidget {
  const ClienteReservacionesPage({super.key});

  @override
  State<ClienteReservacionesPage> createState() => _ClienteReservacionesPageState();
}

class _ClienteReservacionesPageState extends State<ClienteReservacionesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _cargando = true;

  // ✅ DATOS DE EJEMPLO - Tu compañero los traerá de la API
  final List<Map<String, dynamic>> _reservacionesPendientes = [
    {
      'id': '1',
      'empresa': 'Barbería Elite',
      'servicio': 'Corte Premium',
      'empleado': 'Carlos Rodríguez',
      'empleadoFoto': 'https://ui-avatars.com/api/?name=Carlos+Rodriguez&size=200&background=F0D030&color=fff',
      'fecha': DateTime.now().add(const Duration(days: 3)),
      'hora': '10:00 AM',
      'duracion': '45 min',
      'precio': 40000,
      'estado': 'confirmada',
      'iconoServicio': Icons.star,
    },
    {
      'id': '2',
      'empresa': 'Spa Relax',
      'servicio': 'Facial Completo',
      'empleado': 'María González',
      'empleadoFoto': 'https://ui-avatars.com/api/?name=Maria+Gonzalez&size=200&background=F0D030&color=fff',
      'fecha': DateTime.now().add(const Duration(days: 7)),
      'hora': '02:30 PM',
      'duracion': '60 min',
      'precio': 50000,
      'estado': 'confirmada',
      'iconoServicio': Icons.spa,
    },
  ];

  final List<Map<String, dynamic>> _reservacionesCompletadas = [
    {
      'id': '3',
      'empresa': 'Barbería Elite',
      'servicio': 'Corte Clásico',
      'empleado': 'Luis Martínez',
      'empleadoFoto': 'https://ui-avatars.com/api/?name=Luis+Martinez&size=200&background=F0D030&color=fff',
      'fecha': DateTime.now().subtract(const Duration(days: 15)),
      'hora': '11:00 AM',
      'duracion': '30 min',
      'precio': 25000,
      'estado': 'completada',
      'iconoServicio': Icons.content_cut,
      'calificacion': 4.5,
    },
  ];

  final List<Map<String, dynamic>> _reservacionesCanceladas = [
    {
      'id': '4',
      'empresa': 'Spa Relax',
      'servicio': 'Manicure',
      'empleado': 'Ana Pérez',
      'empleadoFoto': 'https://ui-avatars.com/api/?name=Ana+Perez&size=200&background=F0D030&color=fff',
      'fecha': DateTime.now().subtract(const Duration(days: 5)),
      'hora': '03:00 PM',
      'duracion': '40 min',
      'precio': 30000,
      'estado': 'cancelada',
      'iconoServicio': Icons.self_improvement,
      'motivoCancelacion': 'Cancelada por el cliente',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cargarReservaciones();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _cargarReservaciones() async {
    setState(() {
      _cargando = true;
    });

    // ✅ Tu compañero implementará:
    // final reservaciones = await ReservaService.obtenerReservacionesCliente();

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _cargando = false;
    });
  }

  void _mostrarOpcionesReserva(Map<String, dynamic> reserva) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 35, 35, 35),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reserva['servicio'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatearFecha(reserva['fecha'])} • ${reserva['hora']}',
                      style: const TextStyle(color: Colors.white60),
                    ),
                    const SizedBox(height: 24),
                    
                    // ✅ VER DETALLES
                    _buildOpcionBottomSheet(
                      icono: Icons.info_outline,
                      titulo: 'Ver detalles',
                      onTap: () {
                        Navigator.pop(context);
                        _verDetalles(reserva);
                      },
                    ),
                    
                    // ✅ MODIFICAR (Solo si es futura y no cancelada)
                    if (reserva['fecha'].isAfter(DateTime.now()) && 
                        reserva['estado'] != 'cancelada')
                      _buildOpcionBottomSheet(
                        icono: Icons.edit_calendar,
                        titulo: 'Modificar cita',
                        onTap: () {
                          Navigator.pop(context);
                          _modificarReserva(reserva);
                        },
                      ),
                    
                    // ✅ CANCELAR (Solo si es futura y no cancelada)
                    if (reserva['fecha'].isAfter(DateTime.now()) && 
                        reserva['estado'] != 'cancelada')
                      _buildOpcionBottomSheet(
                        icono: Icons.cancel_outlined,
                        titulo: 'Cancelar cita',
                        color: Colors.red,
                        onTap: () {
                          Navigator.pop(context);
                          _confirmarCancelacion(reserva);
                        },
                      ),
                    
                    // ✅ CALIFICAR (Solo si está completada y sin calificación)
                    if (reserva['estado'] == 'completada' && 
                        reserva['calificacion'] == null)
                      _buildOpcionBottomSheet(
                        icono: Icons.star_outline,
                        titulo: 'Calificar servicio',
                        color: const Color.fromARGB(255, 240, 208, 48),
                        onTap: () {
                          Navigator.pop(context);
                          _calificarServicio(reserva);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpcionBottomSheet({
    required IconData icono,
    required String titulo,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icono,
        color: color ?? Colors.white70,
      ),
      title: Text(
        titulo,
        style: TextStyle(
          color: color ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _verDetalles(Map<String, dynamic> reserva) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                      reserva['iconoServicio'],
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
                          reserva['servicio'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          reserva['empresa'],
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              
              _buildDetalleItem('Profesional', reserva['empleado']),
              _buildDetalleItem('Fecha', _formatearFecha(reserva['fecha'])),
              _buildDetalleItem('Hora', reserva['hora']),
              _buildDetalleItem('Duración', reserva['duracion']),
              _buildDetalleItem('Precio', '\$${reserva['precio']}'),
              _buildDetalleItem('Estado', _obtenerTextoEstado(reserva['estado'])),
              
              if (reserva['motivoCancelacion'] != null)
                _buildDetalleItem('Motivo', reserva['motivoCancelacion']),
              
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetalleItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _modificarReserva(Map<String, dynamic> reserva) {
    // TODO: Navegar a página de modificación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🔄 Función de modificar en desarrollo'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _confirmarCancelacion(Map<String, dynamic> reserva) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '¿Cancelar Cita?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Esta acción no se puede deshacer. Se cancelará tu cita para ${reserva['servicio']} el ${_formatearFecha(reserva['fecha'])}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
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
                        'No, volver',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _procesarCancelacion(reserva);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sí, cancelar',
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
      ),
    );
  }

  void _procesarCancelacion(Map<String, dynamic> reserva) async {
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

    // ✅ Tu compañero implementará:
    // await ReservaService.cancelarReserva(reserva['id']);

    await Future.delayed(const Duration(seconds: 2));

    Navigator.pop(context); // Cerrar loading

    // Actualizar estado local
    setState(() {
      reserva['estado'] = 'cancelada';
      _reservacionesPendientes.removeWhere((r) => r['id'] == reserva['id']);
      _reservacionesCanceladas.insert(0, reserva);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Cita cancelada correctamente'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _calificarServicio(Map<String, dynamic> reserva) {
    // TODO: Navegar a página de calificación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('⭐ Función de calificación en desarrollo'),
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final meses = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${fecha.day} ${meses[fecha.month - 1]}, ${fecha.year}';
  }

  String _obtenerTextoEstado(String estado) {
    switch (estado) {
      case 'confirmada':
        return 'Confirmada';
      case 'completada':
        return 'Completada';
      case 'cancelada':
        return 'Cancelada';
      default:
        return estado;
    }
  }

  Color _obtenerColorEstado(String estado) {
    switch (estado) {
      case 'confirmada':
        return Colors.green;
      case 'completada':
        return Colors.blue;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
              _buildTabBar(),
              Expanded(
                child: _cargando ? _buildCargando() : _buildTabBarView(),
              ),
            ],
          ),
        ),
      ),
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
                  'Mis Citas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Gestiona tus reservaciones',
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 208, 48),
              Color.fromARGB(255, 255, 220, 100),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        tabs: const [
          Tab(text: 'Pendientes'),
          Tab(text: 'Completadas'),
          Tab(text: 'Canceladas'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildListaReservaciones(_reservacionesPendientes, 'pendientes'),
        _buildListaReservaciones(_reservacionesCompletadas, 'completadas'),
        _buildListaReservaciones(_reservacionesCanceladas, 'canceladas'),
      ],
    );
  }

  Widget _buildListaReservaciones(List<Map<String, dynamic>> reservaciones, String tipo) {
    if (reservaciones.isEmpty) {
      return _buildListaVacia(tipo);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservaciones.length,
      itemBuilder: (context, index) {
        final reserva = reservaciones[index];
        return _buildTarjetaReserva(reserva);
      },
    );
  }

  Widget _buildTarjetaReserva(Map<String, dynamic> reserva) {
    final esFutura = reserva['fecha'].isAfter(DateTime.now());
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
          onTap: () => _mostrarOpcionesReserva(reserva),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
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
                        reserva['iconoServicio'],
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reserva['servicio'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reserva['empresa'],
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _obtenerColorEstado(reserva['estado']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _obtenerColorEstado(reserva['estado']).withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        _obtenerTextoEstado(reserva['estado']),
                        style: TextStyle(
                          color: _obtenerColorEstado(reserva['estado']),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(reserva['empleadoFoto']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reserva['empleado'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: esFutura 
                                  ? const Color.fromARGB(255, 240, 208, 48)
                                  : Colors.white38,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatearFecha(reserva['fecha']),
                                style: TextStyle(
                                  color: esFutura ? Colors.white70 : Colors.white38,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: esFutura 
                                  ? const Color.fromARGB(255, 240, 208, 48)
                                  : Colors.white38,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                reserva['hora'],
                                style: TextStyle(
                                  color: esFutura ? Colors.white70 : Colors.white38,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${reserva['precio']}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 240, 208, 48),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListaVacia(String tipo) {
    String mensaje;
    IconData icono;
    
    switch (tipo) {
      case 'pendientes':
        mensaje = 'No tienes citas pendientes';
        icono = Icons.event_busy;
        break;
      case 'completadas':
        mensaje = 'Aún no has completado ninguna cita';
        icono = Icons.check_circle_outline;
        break;
      case 'canceladas':
        mensaje = 'No tienes citas canceladas';
        icono = Icons.cancel_outlined;
        break;
      default:
        mensaje = 'No hay reservaciones';
        icono = Icons.event_note;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icono,
            size: 80,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            mensaje,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 16,
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
}