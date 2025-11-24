import 'package:flutter/material.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:proyecto/controllers/EmpleadosController.dart';
import 'FormularioEmpleado.dart';
import 'AsignarServiciosEmpleadoPage.dart';

/// ✅ GESTIÓN DE EMPLEADOS - Integrado con Supabase
class GestionEmpleados extends StatefulWidget {
  final Empresa empresa;

  const GestionEmpleados({super.key, required this.empresa});

  @override
  State<GestionEmpleados> createState() => _GestionEmpleadosState();
}

class _GestionEmpleadosState extends State<GestionEmpleados>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final EmpleadoController _empleadoController = EmpleadoController();
  late AnimationController _animationController;

  List<Empleado> _empleados = [];
  List<Empleado> _empleadosFiltrados = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _cargarEmpleados();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ✅ CARGAR EMPLEADOS DESDE SUPABASE
  Future<void> _cargarEmpleados() async {
    setState(() {
      _cargando = true;
    });

    try {
      final empleados = await _empleadoController
          .obtenerEmpleadosPorEmpresa(widget.empresa.Id ?? '');

      setState(() {
        _empleados = empleados;
        _empleadosFiltrados = List.from(empleados);
        _cargando = false;
      });

      _animationController.forward();
    } catch (e) {
      print('❌ Error cargando empleados: $e');
      setState(() {
        _cargando = false;
      });
      _mostrarSnackBar('Error al cargar empleados', Colors.red);
    }
  }

  // ✅ FILTRAR EMPLEADOS
  void _filtrarEmpleados(String query) {
    setState(() {
      if (query.isEmpty) {
        _empleadosFiltrados = List.from(_empleados);
      } else {
        _empleadosFiltrados = _empleados.where((empleado) {
          final nombre = '${empleado.PrimerNombre ?? ''} ${empleado.PrimerApellido ?? ''}'.toLowerCase();
          final cargo = empleado.Cargo?.toLowerCase() ?? '';
          final queryLower = query.toLowerCase();
          return nombre.contains(queryLower) || cargo.contains(queryLower);
        }).toList();
      }
    });
  }

  // ✅ AGREGAR EMPLEADO
  void _agregarEmpleado() {
    showDialog(
      context: context,
      builder: (context) => FormularioEmpleado(
        empresa: widget.empresa,
        onSuccess: _cargarEmpleados,
      ),
    );
  }

  // ✅ EDITAR EMPLEADO
  void _editarEmpleado(Empleado empleado) {
    showDialog(
      context: context,
      builder: (context) => FormularioEmpleado(
        empresa: widget.empresa,
        empleado: empleado,
        onSuccess: _cargarEmpleados,
      ),
    );
  }

  // ✅ CAMBIAR ESTADO (ACTIVO/INACTIVO)
  Future<void> _cambiarEstadoEmpleado(Empleado empleado) async {
    final nuevoEstado = empleado.Estado == 'Activo' ? 'Inactivo' : 'Activo';
    
    final empleadoActualizado = Empleado(
      Id: empleado.Id,
      Cedula: empleado.Cedula,
      PrimerNombre: empleado.PrimerNombre,
      SegundoNombre: empleado.SegundoNombre,
      PrimerApellido: empleado.PrimerApellido,
      SegundoApellido: empleado.SegundoApellido,
      Telefono: empleado.Telefono,
      Correo: empleado.Correo,
      Sexo: empleado.Sexo,
      Foto: empleado.Foto,
      FechaDeInicio: empleado.FechaDeInicio,
      FechaActual: empleado.FechaActual,
      Cargo: empleado.Cargo,
      Estado: nuevoEstado,
      Estacion: empleado.Estacion,
      empresa: empleado.empresa,
    );

    _mostrarSnackBar('Actualizando estado...', Colors.orange);

    final exito = await _empleadoController.actualizarEmpleado(empleadoActualizado);

    if (exito) {
      await _cargarEmpleados();
      _mostrarSnackBar(
        '${empleado.PrimerNombre} ${nuevoEstado.toLowerCase()}',
        nuevoEstado == 'Activo' ? Colors.green : Colors.orange,
      );
    } else {
      _mostrarSnackBar('Error al cambiar estado', Colors.red);
    }
  }

  // ✅ ELIMINAR EMPLEADO
  void _eliminarEmpleado(Empleado empleado) {
    final nombreCompleto = '${empleado.PrimerNombre ?? ''} ${empleado.PrimerApellido ?? ''}'.trim();
    
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
                '¿Eliminar Empleado?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¿Estás seguro de eliminar a $nombreCompleto?',
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

                        _mostrarSnackBar('Eliminando empleado...', Colors.orange);

                        final exito = await _empleadoController
                            .eliminarEmpleado(empleado.Id ?? '');

                        if (exito) {
                          await _cargarEmpleados();
                          _mostrarSnackBar(
                            '✅ Empleado eliminado',
                            Colors.green,
                          );
                        } else {
                          _mostrarSnackBar('Error al eliminar empleado', Colors.red);
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

  // ✅ WIDGETS AUXILIARES
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
                  'Empleados - ${widget.empresa.Nombre}',
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
        onChanged: _filtrarEmpleados,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar empleado...',
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
    final activos = _empleados.where((e) => e.Estado == 'Activo').length;
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
            child: const Icon(
              Icons.people_rounded,
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
    return RefreshIndicator(
      onRefresh: _cargarEmpleados,
      color: const Color.fromARGB(255, 240, 208, 48),
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _empleadosFiltrados.length,
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: _animationController,
            child: _buildEmpleadoCard(_empleadosFiltrados[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmpleadoCard(Empleado empleado) {
    final nombreCompleto = '${empleado.PrimerNombre ?? ''} ${empleado.SegundoNombre ?? ''} ${empleado.PrimerApellido ?? ''} ${empleado.SegundoApellido ?? ''}'.trim();
    final esActivo = empleado.Estado == 'Activo';

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
                      colors: esActivo
                          ? [Colors.green, Colors.green.shade300]
                          : [Colors.grey, Colors.grey.shade400],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: empleado.Foto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(
                            empleado.Foto!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          empleado.Sexo == 'Femenino'
                              ? Icons.woman_rounded
                              : Icons.man_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
                const SizedBox(width: 16),

                // Información
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              nombreCompleto,
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
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: esActivo
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              empleado.Estado ?? 'Sin estado',
                              style: TextStyle(
                                color: esActivo ? Colors.green : Colors.orange,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        empleado.Cargo ?? 'Sin cargo',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_rounded,
                            color: Colors.white.withOpacity(0.5),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              empleado.Telefono ?? 'Sin teléfono',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Menú de opciones
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
                        _editarEmpleado(empleado);
                        break;
                      case 'estado':
                        _cambiarEstadoEmpleado(empleado);
                        break;
                      case 'eliminar':
                        _eliminarEmpleado(empleado);
                        break;
                      case 'servicios':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AsignarServiciosEmpleadoPage(
                              empleado: empleado,
                              empresa: widget.empresa,
                            ),
                          ),
                        ).then((value) {
                          if (value == true) {
                          }
                        });
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
                    PopupMenuItem(
                      value: 'estado',
                      child: Row(
                        children: [
                          Icon(
                            esActivo
                                ? Icons.toggle_on_rounded
                                : Icons.toggle_off_rounded,
                            color: esActivo ? Colors.green : Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            esActivo ? 'Desactivar' : 'Activar',
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
                          Text('Eliminar', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),

                    const PopupMenuItem(
                      value: 'servicios',
                      child: Row(
                        children: [
                          Icon(Icons.room_service_rounded, color: Colors.purple, size: 20),
                          SizedBox(width: 12),
                          Text('Asignar Servicios', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Información adicional
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.email_rounded,
                        color: Colors.white.withOpacity(0.5),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          empleado.Correo ?? 'Sin correo',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.credit_card_rounded,
                        color: Colors.white.withOpacity(0.5),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CC: ${empleado.Cedula ?? 'Sin cédula'}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        empleado.Sexo == 'Femenino'
                            ? Icons.female_rounded
                            : Icons.male_rounded,
                        color: empleado.Sexo == 'Femenino'
                            ? Colors.pink.shade300
                            : Colors.blue.shade300,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        empleado.Sexo ?? 'Sin especificar',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (empleado.FechaDeInicio != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white.withOpacity(0.5),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Inicio: ${_formatearFecha(empleado.FechaDeInicio!)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
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
    );
  }

  // ✅ FORMATEAR FECHA
  String _formatearFecha(DateTime fecha) {
    final meses = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
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
              Icons.people_outline_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
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