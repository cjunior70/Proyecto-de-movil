import 'package:flutter/material.dart';
import 'reservarservicio.dart'; // ✅ Importar la página de reserva

/// ✅ EMPLEADOS DISPONIBLES CON DISEÑO OSCURO
class ServicioEmpleadosPage extends StatefulWidget {
  final String? empresaId;
  final Map<String, dynamic> empresa; // ✅ Agregado
  final Map<String, dynamic> servicio;

  const ServicioEmpleadosPage({
    super.key,
    this.empresaId,
    required this.empresa, // ✅ Agregado
    required this.servicio,
  });

  @override
  State<ServicioEmpleadosPage> createState() => _ServicioEmpleadosPageState();
}

class _ServicioEmpleadosPageState extends State<ServicioEmpleadosPage> {
  bool _cargando = true;
  String? _empleadoSeleccionado;

  // ✅ DATOS DE EJEMPLO
  final List<Map<String, dynamic>> empleados = [
    {
      'id': '1',
      'nombre': 'Carlos Rodríguez',
      'especialidad': 'Barbero Senior',
      'experiencia': '5 años',
      'rating': 4.9,
      'totalReseñas': 87,
      'foto': 'https://ui-avatars.com/api/?name=Carlos+Rodriguez&size=200&background=F0D030&color=fff',
      'disponible': true,
    },
    {
      'id': '2',
      'nombre': 'María González',
      'especialidad': 'Estilista Profesional',
      'experiencia': '8 años',
      'rating': 4.8,
      'totalReseñas': 124,
      'foto': 'https://ui-avatars.com/api/?name=Maria+Gonzalez&size=200&background=F0D030&color=fff',
      'disponible': true,
    },
    {
      'id': '3',
      'nombre': 'Luis Martínez',
      'especialidad': 'Barbero Clásico',
      'experiencia': '3 años',
      'rating': 4.7,
      'totalReseñas': 45,
      'foto': 'https://ui-avatars.com/api/?name=Luis+Martinez&size=200&background=F0D030&color=fff',
      'disponible': false,
    },
    {
      'id': '4',
      'nombre': 'Ana Pérez',
      'especialidad': 'Colorista Experta',
      'experiencia': '6 años',
      'rating': 4.9,
      'totalReseñas': 98,
      'foto': 'https://ui-avatars.com/api/?name=Ana+Perez&size=200&background=F0D030&color=fff',
      'disponible': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  void _cargarEmpleados() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _cargando = false;
    });
  }

  void _seleccionarEmpleado(String empleadoId) {
    setState(() {
      _empleadoSeleccionado = empleadoId;
    });
  }

  void _continuarConReserva() {
    if (_empleadoSeleccionado == null) {
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

    final empleado = empleados.firstWhere((e) => e['id'] == _empleadoSeleccionado);
    
    // ✅ NAVEGAR A PÁGINA DE RESERVA
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservaPage(
          empresaId: widget.empresaId,
          empresa: widget.empresa,
          servicio: widget.servicio,
          empleado: empleado,
        ),
      ),
    );
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.servicio['nombre'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoServicio(),
          const SizedBox(height: 24),

          const Text(
            "Profesionales Disponibles",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: empleados.length,
            itemBuilder: (context, index) {
              final empleado = empleados[index];
              return _buildTarjetaEmpleado(empleado);
            },
          ),
          const SizedBox(height: 100),
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
        border: Border.all(color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.3)),
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
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.white60),
                    const SizedBox(width: 4),
                    Text(
                      widget.servicio['duracion'],
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '\$${widget.servicio['precio']}',
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

  Widget _buildTarjetaEmpleado(Map<String, dynamic> empleado) {
    final bool seleccionado = _empleadoSeleccionado == empleado['id'];
    final bool disponible = empleado['disponible'];

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
          onTap: disponible ? () => _seleccionarEmpleado(empleado['id']) : null,
          child: Opacity(
            opacity: disponible ? 1.0 : 0.5,
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
                          backgroundImage: NetworkImage(empleado['foto']),
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
                      if (!disponible)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.schedule,
                                color: Colors.white,
                                size: 24,
                              ),
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
                          empleado['nombre'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          empleado['especialidad'],
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.work_outline, size: 14, color: Colors.white38),
                            const SizedBox(width: 4),
                            Text(
                              empleado['experiencia'],
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color.fromARGB(255, 240, 208, 48), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${empleado['rating']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 240, 208, 48),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${empleado['totalReseñas']})',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (!disponible)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Text(
                        'No disponible',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
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