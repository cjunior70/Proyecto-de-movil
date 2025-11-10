import 'package:flutter/material.dart';
import 'package:proyecto/models/empresa_model.dart';

/// ✅ GESTIÓN DE EMPLEADOS - Diseño Oscuro Premium con CRUD
class GestionEmpleados extends StatefulWidget {
  final Empresa empresa;

  const GestionEmpleados({super.key, required this.empresa});

  @override
  State<GestionEmpleados> createState() => _GestionEmpleadosState();
}

class _GestionEmpleadosState extends State<GestionEmpleados>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  // ✅ DATOS DE EJEMPLO - Tu compañero los reemplazará con API
  List<Map<String, dynamic>> _empleados = [
    {
      'id': '1',
      'nombre': 'Juan Pérez',
      'cargo': 'Barbero Senior',
      'telefono': '312 345 6789',
      'email': 'juan.perez@gmail.com',
      'foto': null,
      'activo': true,
      'especialidades': ['Corte Clásico', 'Barba', 'Tinte'],
    },
    {
      'id': '2',
      'nombre': 'María García',
      'cargo': 'Estilista',
      'telefono': '315 678 9012',
      'email': 'maria.garcia@gmail.com',
      'foto': null,
      'activo': true,
      'especialidades': ['Manicure', 'Pedicure', 'Tratamiento Facial'],
    },
    {
      'id': '3',
      'nombre': 'Carlos Ruiz',
      'cargo': 'Barbero Junior',
      'telefono': '318 901 2345',
      'email': 'carlos.ruiz@gmail.com',
      'foto': null,
      'activo': false,
      'especialidades': ['Corte Moderno'],
    },
  ];

  List<Map<String, dynamic>> _empleadosFiltrados = [];
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _empleadosFiltrados = List.from(_empleados);
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _filtrarEmpleados(String query) {
    setState(() {
      if (query.isEmpty) {
        _empleadosFiltrados = List.from(_empleados);
      } else {
        _empleadosFiltrados = _empleados.where((empleado) {
          return empleado['nombre']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              empleado['cargo'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _agregarEmpleado() {
    // TODO: Navegar a formulario de registro
    _mostrarSnackBar('Abrir formulario de nuevo empleado', Colors.blue);
  }

  void _editarEmpleado(Map<String, dynamic> empleado) {
    // TODO: Navegar a formulario de edición
    _mostrarSnackBar('Editar: ${empleado['nombre']}', Colors.orange);
  }

  void _cambiarEstadoEmpleado(String id) {
    setState(() {
      final index = _empleados.indexWhere((e) => e['id'] == id);
      if (index != -1) {
        _empleados[index]['activo'] = !_empleados[index]['activo'];
        _empleadosFiltrados = List.from(_empleados);
      }
    });

    final empleado = _empleados.firstWhere((e) => e['id'] == id);
    _mostrarSnackBar(
      '${empleado['nombre']} ${empleado['activo'] ? 'activado' : 'desactivado'}',
      empleado['activo'] ? Colors.green : Colors.orange,
    );
  }

  void _eliminarEmpleado(Map<String, dynamic> empleado) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 35, 35, 35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_rounded,
                    color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Eliminar Empleado?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¿Estás seguro de eliminar a ${empleado['nombre']}?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar',
                          style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _empleados.removeWhere((e) => e['id'] == empleado['id']);
                          _empleadosFiltrados = List.from(_empleados);
                        });
                        Navigator.pop(context);
                        _mostrarSnackBar('Empleado eliminado', Colors.red);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Eliminar',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
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
              _buildHeader(),
              _buildSearchBar(),
              _buildStatsCard(),
              Expanded(
                child: _cargando
                    ? _buildLoadingState()
                    : _empleadosFiltrados.isEmpty
                        ? _buildEmptyState()
                        : _buildListaEmpleados(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ✅ HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestión de',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  'Empleados',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ BARRA DE BÚSQUEDA
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: _filtrarEmpleados,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar empleado...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: const Icon(Icons.search_rounded,
              color: Color.fromARGB(255, 240, 208, 48)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded,
                      color: Colors.white.withOpacity(0.7)),
                  onPressed: () {
                    _searchController.clear();
                    _filtrarEmpleados('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 240, 208, 48), width: 2),
          ),
        ),
      ),
    );
  }

  // ✅ ESTADÍSTICAS
  Widget _buildStatsCard() {
    final activos = _empleados.where((e) => e['activo'] == true).length;
    final inactivos = _empleados.length - activos;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.people_rounded,
                color: Color.fromARGB(255, 240, 208, 48), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_empleadosFiltrados.length} Empleados',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$activos activos • $inactivos inactivos',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
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

  // ✅ LISTA DE EMPLEADOS
  Widget _buildListaEmpleados() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: _empleadosFiltrados.length,
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: _animationController,
          child: _buildEmpleadoCard(_empleadosFiltrados[index]),
        );
      },
    );
  }

  Widget _buildEmpleadoCard(Map<String, dynamic> empleado) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: empleado['activo']
                          ? [Colors.green, Colors.green.shade300]
                          : [Colors.grey, Colors.grey.shade400],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: empleado['foto'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(empleado['foto'],
                              fit: BoxFit.cover),
                        )
                      : const Icon(Icons.person_rounded,
                          color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              empleado['nombre'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: empleado['activo']
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              empleado['activo'] ? 'Activo' : 'Inactivo',
                              style: TextStyle(
                                color: empleado['activo']
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        empleado['cargo'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone_rounded,
                              color: Colors.white.withOpacity(0.5), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            empleado['telefono'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Menú
                PopupMenuButton<String>(
                  color: const Color.fromARGB(255, 40, 40, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  icon: Icon(Icons.more_vert_rounded,
                      color: Colors.white.withOpacity(0.7)),
                  onSelected: (value) {
                    switch (value) {
                      case 'editar':
                        _editarEmpleado(empleado);
                        break;
                      case 'estado':
                        _cambiarEstadoEmpleado(empleado['id']);
                        break;
                      case 'eliminar':
                        _eliminarEmpleado(empleado);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded, color: Colors.blue, size: 20),
                          SizedBox(width: 12),
                          Text('Editar',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'estado',
                      child: Row(
                        children: [
                          Icon(
                            empleado['activo']
                                ? Icons.toggle_on_rounded
                                : Icons.toggle_off_rounded,
                            color: empleado['activo'] ? Colors.green : Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            empleado['activo'] ? 'Desactivar' : 'Activar',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'eliminar',
                      child: Row(
                        children: [
                          Icon(Icons.delete_rounded, color: Colors.red, size: 20),
                          SizedBox(width: 12),
                          Text('Eliminar',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Especialidades
            if (empleado['especialidades'] != null &&
                (empleado['especialidades'] as List).isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: (empleado['especialidades'] as List)
                    .map((esp) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 240, 208, 48)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color.fromARGB(255, 240, 208, 48)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            esp,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 240, 208, 48),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ✅ ESTADOS VACÍO Y CARGA
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
            child: Icon(Icons.people_outline_rounded,
                size: 80, color: Colors.white.withOpacity(0.3)),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay empleados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _searchController.text.isEmpty
                ? 'Presiona + para agregar tu primer empleado'
                : 'No se encontraron resultados',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color.fromARGB(255, 240, 208, 48),
      ),
    );
  }

  // ✅ FAB
  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _agregarEmpleado,
      backgroundColor: const Color.fromARGB(255, 240, 208, 48),
      icon: const Icon(Icons.person_add_rounded),
      label: const Text(
        'Nuevo Empleado',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}