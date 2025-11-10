import 'package:flutter/material.dart';
import 'package:proyecto/models/empresa_model.dart';

/// ✅ GESTIÓN DE SERVICIOS - Diseño Oscuro Premium con CRUD Completo
class GestionServicios extends StatefulWidget {
  final Empresa empresa;

  const GestionServicios({super.key, required this.empresa});

  @override
  State<GestionServicios> createState() => _GestionServiciosState();
}

class _GestionServiciosState extends State<GestionServicios>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  // ✅ DATOS DE EJEMPLO - Tu compañero los reemplazará con API
  List<Map<String, dynamic>> _servicios = [
    {
      'id': '1',
      'nombre': 'Corte Clásico',
      'descripcion': 'Corte de cabello tradicional',
      'precio': 25000.0,
      'duracion': '30 minutos',
      'categoria': 'Corte',
      'disponible': true,
    },
    {
      'id': '2',
      'nombre': 'Barba Completa',
      'descripcion': 'Arreglo de barba profesional',
      'precio': 15000.0,
      'duracion': '20 minutos',
      'categoria': 'Barba',
      'disponible': true,
    },
    {
      'id': '3',
      'nombre': 'Tinte Completo',
      'descripcion': 'Coloración completa del cabello',
      'precio': 45000.0,
      'duracion': '90 minutos',
      'categoria': 'Coloración',
      'disponible': false,
    },
  ];

  List<Map<String, dynamic>> _serviciosFiltrados = [];
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _serviciosFiltrados = List.from(_servicios);
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _filtrarServicios(String query) {
    setState(() {
      if (query.isEmpty) {
        _serviciosFiltrados = List.from(_servicios);
      } else {
        _serviciosFiltrados = _servicios.where((servicio) {
          return servicio['nombre']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              servicio['categoria'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _agregarServicio() {
    _mostrarFormularioServicio(null);
  }

  void _editarServicio(Map<String, dynamic> servicio) {
    _mostrarFormularioServicio(servicio);
  }

  void _cambiarDisponibilidad(String id) {
    setState(() {
      final index = _servicios.indexWhere((s) => s['id'] == id);
      if (index != -1) {
        _servicios[index]['disponible'] = !_servicios[index]['disponible'];
        _serviciosFiltrados = List.from(_servicios);
      }
    });

    final servicio = _servicios.firstWhere((s) => s['id'] == id);
    _mostrarSnackBar(
      '${servicio['nombre']} ${servicio['disponible'] ? 'disponible' : 'no disponible'}',
      servicio['disponible'] ? Colors.green : Colors.orange,
    );
  }

  void _eliminarServicio(Map<String, dynamic> servicio) {
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
                '¿Eliminar Servicio?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¿Estás seguro de eliminar "${servicio['nombre']}"?',
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
                          _servicios
                              .removeWhere((s) => s['id'] == servicio['id']);
                          _serviciosFiltrados = List.from(_servicios);
                        });
                        Navigator.pop(context);
                        _mostrarSnackBar('Servicio eliminado', Colors.red);
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

  void _mostrarFormularioServicio(Map<String, dynamic>? servicio) {
    final nombreController =
        TextEditingController(text: servicio?['nombre'] ?? '');
    final descripcionController =
        TextEditingController(text: servicio?['descripcion'] ?? '');
    final precioController = TextEditingController(
        text: servicio != null ? servicio['precio'].toString() : '');
    final duracionController = TextEditingController(
        text: servicio?['duracion']?.replaceAll(' minutos', '') ?? '');
    final categoriaController =
        TextEditingController(text: servicio?['categoria'] ?? '');

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 208, 48)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.room_service_rounded,
                        color: Color.fromARGB(255, 240, 208, 48),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        servicio == null ? 'Nuevo Servicio' : 'Editar Servicio',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: nombreController,
                  label: 'Nombre del servicio',
                  icon: Icons.label_rounded,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: descripcionController,
                  label: 'Descripción',
                  icon: Icons.description_rounded,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: precioController,
                        label: 'Precio',
                        icon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: duracionController,
                        label: 'Duración (min)',
                        icon: Icons.schedule_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: categoriaController,
                  label: 'Categoría',
                  icon: Icons.category_rounded,
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
                        child: const Text('Cancelar',
                            style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nombreController.text.isEmpty ||
                              precioController.text.isEmpty) {
                            _mostrarSnackBar(
                                'Completa todos los campos', Colors.red);
                            return;
                          }

                          final nuevoServicio = {
                            'id': servicio?['id'] ??
                                DateTime.now().millisecondsSinceEpoch.toString(),
                            'nombre': nombreController.text,
                            'descripcion': descripcionController.text,
                            'precio': double.parse(precioController.text),
                            'duracion': '${duracionController.text} minutos',
                            'categoria': categoriaController.text,
                            'disponible': servicio?['disponible'] ?? true,
                          };

                          setState(() {
                            if (servicio == null) {
                              _servicios.add(nuevoServicio);
                            } else {
                              final index = _servicios
                                  .indexWhere((s) => s['id'] == servicio['id']);
                              if (index != -1) {
                                _servicios[index] = nuevoServicio;
                              }
                            }
                            _serviciosFiltrados = List.from(_servicios);
                          });

                          Navigator.pop(context);
                          _mostrarSnackBar(
                            servicio == null
                                ? 'Servicio agregado'
                                : 'Servicio actualizado',
                            Colors.green,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 240, 208, 48),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          servicio == null ? 'Agregar' : 'Actualizar',
                          style: const TextStyle(
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 240, 208, 48),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
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
                    : _serviciosFiltrados.isEmpty
                        ? _buildEmptyState()
                        : _buildListaServicios(),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gestión de',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  'Servicios',
                  style: TextStyle(
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
        onChanged: _filtrarServicios,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar servicio...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: const Icon(Icons.search_rounded,
              color: Color.fromARGB(255, 240, 208, 48)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded,
                      color: Colors.white.withOpacity(0.7)),
                  onPressed: () {
                    _searchController.clear();
                    _filtrarServicios('');
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
    final disponibles =
        _servicios.where((s) => s['disponible'] == true).length;
    final noDisponibles = _servicios.length - disponibles;

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
            child: const Icon(Icons.room_service_rounded,
                color: Color.fromARGB(255, 240, 208, 48), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_serviciosFiltrados.length} Servicios',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$disponibles disponibles • $noDisponibles no disponibles',
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

  // ✅ LISTA DE SERVICIOS
  Widget _buildListaServicios() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: _serviciosFiltrados.length,
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: _animationController,
          child: _buildServicioCard(_serviciosFiltrados[index]),
        );
      },
    );
  }

  Widget _buildServicioCard(Map<String, dynamic> servicio) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: servicio['disponible']
                          ? [
                              const Color.fromARGB(255, 240, 208, 48),
                              const Color.fromARGB(255, 255, 220, 100)
                            ]
                          : [Colors.grey, Colors.grey.shade400],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.room_service_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              servicio['nombre'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
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
                              color: servicio['disponible']
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              servicio['disponible'] ? 'Disponible' : 'No disponible',
                              style: TextStyle(
                                color: servicio['disponible']
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        servicio['categoria'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  color: const Color.fromARGB(255, 40, 40, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  icon: Icon(Icons.more_vert_rounded,
                      color: Colors.white.withOpacity(0.7)),
                  onSelected: (value) {
                    switch (value) {
                      case 'editar':
                        _editarServicio(servicio);
                        break;
                      case 'disponibilidad':
                        _cambiarDisponibilidad(servicio['id']);
                        break;
                      case 'eliminar':
                        _eliminarServicio(servicio);
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
                      value: 'disponibilidad',
                      child: Row(
                        children: [
                          Icon(
                            servicio['disponible']
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: servicio['disponible']
                                ? Colors.orange
                                : Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            servicio['disponible']
                                ? 'Desactivar'
                                : 'Activar',
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
            const SizedBox(height: 12),
            Text(
              servicio['descripcion'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.attach_money_rounded,
                    color: const Color.fromARGB(255, 240, 208, 48), size: 18),
                const SizedBox(width: 4),
                Text(
                  '\$${servicio['precio'].toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 240, 208, 48),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Icon(Icons.schedule_rounded,
                    color: Colors.white.withOpacity(0.5), size: 16),
                const SizedBox(width: 4),
                Text(
                  servicio['duracion'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ ESTADOS
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
            child: Icon(Icons.room_service_outlined,
                size: 80, color: Colors.white.withOpacity(0.3)),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay servicios',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _searchController.text.isEmpty
                ? 'Presiona + para agregar tu primer servicio'
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

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _agregarServicio,
      backgroundColor: const Color.fromARGB(255, 240, 208, 48),
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'Nuevo Servicio',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}