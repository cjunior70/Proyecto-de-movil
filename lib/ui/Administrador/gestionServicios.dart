import 'package:flutter/material.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/controllers/ServiciosController.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final ServicioController _servicioController = ServicioController();
  late AnimationController _animationController;

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
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

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

      _animationController.forward();
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
        _serviciosFiltrados = _servicios.where((servicio) {
          final nombre = servicio.Nombre?.toLowerCase() ?? '';
          final descripcion = servicio.Descripcion?.toLowerCase() ?? '';
          final queryLower = query.toLowerCase();
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
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                  size: 36,
                ),
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
                '¿Estás seguro de eliminar "${servicio.Nombre}"?\n\nSe notificará a empleados y clientes.',
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
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        
                        // Mostrar loader
                        _mostrarSnackBar('Eliminando servicio...', Colors.orange);

                        final exito = await _servicioController
                            .eliminarServicio(servicio.Id);

                        if (exito) {
                          // TODO: Enviar notificación a empleados
                          _enviarNotificacionEliminacion(servicio);
                          
                          // Recargar lista
                          await _cargarServicios();
                          _mostrarSnackBar(
                            '✅ Servicio eliminado. Notificación enviada.',
                            Colors.green,
                          );
                        } else {
                          _mostrarSnackBar('Error al eliminar servicio', Colors.red);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Eliminar',
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

  // ✅ FORMULARIO DE SERVICIO (AGREGAR/EDITAR)
  void _mostrarFormularioServicio(Servicio? servicio) {
    final nombreController = TextEditingController(text: servicio?.Nombre ?? '');
    final descripcionController = TextEditingController(text: servicio?.Descripcion ?? '');
    final precioController = TextEditingController(
      text: servicio?.Precio != null ? servicio!.Precio.toString() : '',
    );
    
    // Convertir Duration a minutos para el formulario
    final duracionMinutos = servicio?.TiempoPromedio.inMinutes ?? 30;
    final duracionController = TextEditingController(
      text: duracionMinutos.toString(),
    );

    final formKey = GlobalKey<FormState>();

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
            child: Form(
              key: formKey,
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
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: descripcionController,
                    label: 'Descripción',
                    icon: Icons.description_rounded,
                    maxLines: 3,
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
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Requerido';
                            }
                            if (double.tryParse(value!) == null) {
                              return 'Número inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: duracionController,
                          label: 'Duración (min)',
                          icon: Icons.schedule_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Requerido';
                            }
                            if (int.tryParse(value!) == null) {
                              return 'Inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
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
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            Navigator.pop(context);

                            // Crear o actualizar servicio
                            final nuevoServicio = Servicio(
                              Id: servicio?.Id ?? _uuid.v4(),
                              Nombre: nombreController.text.trim(),
                              Descripcion: descripcionController.text.trim(),
                              Precio: double.parse(precioController.text),
                              TiempoPromedio: Duration(
                                minutes: int.parse(duracionController.text),
                              ),
                            );

                            bool exito = false;
                            
                            if (servicio == null) {
                              // ✅ AGREGAR
                              _mostrarSnackBar('Guardando servicio...', Colors.orange);
                              exito = await _servicioController.guardarServicio(nuevoServicio);
                              
                              if (exito) {
                                await _cargarServicios();
                                _mostrarSnackBar(
                                  '✅ Servicio agregado exitosamente',
                                  Colors.green,
                                );
                              }
                            } else {
                              // ✅ EDITAR
                              _mostrarSnackBar('Actualizando servicio...', Colors.orange);
                              exito = await _servicioController.actualizarServicio(nuevoServicio);
                              
                              if (exito) {
                                // TODO: Enviar notificación a empleados y clientes
                                _enviarNotificacionEdicion(nuevoServicio);
                                
                                await _cargarServicios();
                                _mostrarSnackBar(
                                  '✅ Servicio actualizado. Notificación enviada.',
                                  Colors.green,
                                );
                              }
                            }

                            if (!exito) {
                              _mostrarSnackBar(
                                'Error al guardar el servicio',
                                Colors.red,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 240, 208, 48),
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
      ),
    );
  }

  // ✅ NOTIFICACIONES (TODO: Implementar sistema real)
  void _enviarNotificacionEdicion(Servicio servicio) {
    // TODO: Implementar sistema de notificaciones
    // Aquí deberías enviar notificaciones push o email a:
    // 1. Empleados de la empresa
    // 2. Clientes con reservas futuras de este servicio
    print('📧 Notificación enviada: Servicio "${servicio.Nombre}" actualizado');
  }

  void _enviarNotificacionEliminacion(Servicio servicio) {
    // TODO: Implementar sistema de notificaciones
    print('📧 Notificación enviada: Servicio "${servicio.Nombre}" eliminado');
  }

  // ✅ TEXTFIELD PERSONALIZADO
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
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

  // ✅ FORMATEAR DURACIÓN
  String _formatearDuracion(Duration duracion) {
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60);
    
    if (horas > 0) {
      return '$horas h ${minutos > 0 ? "$minutos min" : ""}';
    }
    return '$minutos min';
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestión de',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  'Servicios - ${widget.empresa.Nombre}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
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
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color.fromARGB(255, 240, 208, 48),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.white.withOpacity(0.7),
                  ),
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
              color: Color.fromARGB(255, 240, 208, 48),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  // ✅ ESTADÍSTICAS
  Widget _buildStatsCard() {
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
            child: const Icon(
              Icons.room_service_rounded,
              color: Color.fromARGB(255, 240, 208, 48),
              size: 24,
            ),
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
                  _searchController.text.isEmpty
                      ? 'Total registrados'
                      : 'Resultados de búsqueda',
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
    return RefreshIndicator(
      onRefresh: _cargarServicios,
      color: const Color.fromARGB(255, 240, 208, 48),
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _serviciosFiltrados.length,
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: _animationController,
            child: _buildServicioCard(_serviciosFiltrados[index]),
          );
        },
      ),
    );
  }

  Widget _buildServicioCard(Servicio servicio) {
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
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 240, 208, 48),
                        Color.fromARGB(255, 255, 220, 100),
                      ],
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
                      Text(
                        servicio.Nombre ?? 'Sin nombre',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (servicio.Descripcion != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          servicio.Descripcion!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  color: const Color.fromARGB(255, 40, 40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'editar':
                        _editarServicio(servicio);
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
                          Text('Editar', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'eliminar',
                      child: Row(
                        children: [
                          Icon(Icons.delete_rounded, color: Colors.red, size: 20),
                          SizedBox(width: 12),
                          Text('Eliminar', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (servicio.Descripcion != null && servicio.Descripcion!.length > 30) ...[
              const SizedBox(height: 12),
              Text(
                servicio.Descripcion!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.attach_money_rounded,
                  color: Color.fromARGB(255, 240, 208, 48),
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '\$${servicio.Precio?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 240, 208, 48),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Icon(
                  Icons.schedule_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatearDuracion(servicio.TiempoPromedio),
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

  // ✅ ESTADOS VACÍO Y CARGANDO
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
            child: Icon(
              Icons.room_service_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
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