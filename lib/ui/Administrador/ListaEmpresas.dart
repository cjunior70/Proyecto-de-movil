import 'package:flutter/material.dart';
import 'package:proyecto/controllers/EmpresaController.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/ui/Administrador/mostrarEmpresa.dart';
import 'package:proyecto/ui/Administrador/RegistrarEmpresaPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ✅ Lista de empresas con diseño oscuro premium y funcionalidad completa
class ListaEmpresas extends StatefulWidget {
  const ListaEmpresas({super.key});

  @override
  State<ListaEmpresas> createState() => _ListaEmpresasState();
}

class _ListaEmpresasState extends State<ListaEmpresas>
    with SingleTickerProviderStateMixin {
  final EmpresaController _empresaController = EmpresaController();
  final TextEditingController _searchController = TextEditingController();
  List<Empresa> _empresas = [];
  List<Empresa> _empresasFiltradas = [];
  bool _isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _cargarEmpresas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _cargarEmpresas() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('uid');

    if (uid == null) {
      //print("❌ Error: UID es null");
      return;
    }

    // ⭐ IMPORTANTE: ESPERAR LA RESPUESTA
    final empresas = await _empresaController.obtenerEmpresasPorUsuario(uid);

    setState(() {
      _empresas = empresas;
      _empresasFiltradas = List.from(empresas);
      _isLoading = false;
    });

    _animationController.forward();

    //print("Empresas cargadas: $_empresas");
  }


  void _filtrarEmpresas(String query) {
    setState(() {
      if (query.isEmpty) {
        _empresasFiltradas = List.from(_empresas);
      } else {
        _empresasFiltradas = _empresas.where((empresa) {
          return empresa.Nombre!.toLowerCase().contains(query.toLowerCase()) ||
              empresa.DescripcionUbicacion!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _navegarADetalle(Empresa empresa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MostrarEmpresa(empresa: empresa),
      ),
    );
  }

  void _navegarARegistrar() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrarEmpresaPage(),
      ),
    );

    if (result != null && result is Empresa) {
      setState(() {
        _empresas.add(result);
        _empresasFiltradas = List.from(_empresas);
      });
      _mostrarSnackBar('Empresa registrada exitosamente', Colors.green);
    }
  }

  void _eliminarEmpresa(Empresa empresa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Eliminar Empresa',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Estás seguro de eliminar "${empresa.Nombre}"? Esta acción no se puede deshacer.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final String idEmpresa = empresa.Id!; 

              // 1. Eliminas de la lista visible
              setState(() {
                _empresas.removeWhere((e) => e.Id == idEmpresa);
                _empresasFiltradas.removeWhere((e) => e.Id == idEmpresa);
              });

              // 2. Llamas al controlador (esperar por si es async)
              await _empresaController.eliminarEmpresa(idEmpresa);

              // 3. Cierras modal
              Navigator.pop(context);

              // 4. SnackBar
              _mostrarSnackBar('Empresa eliminada', Colors.red);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Eliminar'),
          )
        ],
      ),
    );
  }

  void _mostrarSnackBar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
              // ✅ Header personalizado
              _buildHeader(),

              // ✅ Barra de búsqueda
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildSearchBar(),
              ),

              // ✅ Estadísticas
              _buildStatsCard(),

              // ✅ Lista de empresas
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _empresasFiltradas.isEmpty
                        ? _buildEmptyState()
                        : _buildListaEmpresas(),
              ),
            ],
          ),
        ),
      ),

      // ✅ FAB mejorado
      floatingActionButton: _buildFAB(),
    );
  }

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
                  "Gestión de",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Empresas",
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filtrarEmpresas,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Buscar empresa...",
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
                    _filtrarEmpresas('');
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
              Icons.business_rounded,
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
                  '${_empresasFiltradas.length} Empresas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _searchController.text.isEmpty
                      ? 'Total registradas'
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

  Widget _buildListaEmpresas() {
    return RefreshIndicator(
      onRefresh: () async {
        _cargarEmpresas();
      },
      color: const Color.fromARGB(255, 240, 208, 48),
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: _empresasFiltradas.length,
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: _animationController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  index * 0.1,
                  1.0,
                  curve: Curves.easeOut,
                ),
              )),
              child: _buildEmpresaCard(_empresasFiltradas[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpresaCard(Empresa empresa) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navegarADetalle(empresa),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ícono de empresa
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 240, 208, 48),
                        Color.fromARGB(255, 255, 220, 100),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 240, 208, 48)
                            .withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.business_rounded,
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
                      Text(
                        empresa.Nombre!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        empresa.DescripcionUbicacion!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color.fromARGB(255, 240, 208, 48),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          // Text(
                          //   empresa.ratingPromedio.toStringAsFixed(1),
                          //   style: const TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //     fontSize: 13,
                          //   ),
                          // ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.reviews_rounded,
                            color: Colors.white.withOpacity(0.5),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          // Text(
                          //   '${empresa.totalReviews}',
                          //   style: TextStyle(
                          //     color: Colors.white.withOpacity(0.7),
                          //     fontSize: 13,
                          //   ),
                          // ),
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
                      case 'ver':
                        _navegarADetalle(empresa);
                        break;
                      case 'eliminar':
                        _eliminarEmpresa(empresa);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'ver',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_rounded,
                              color: Colors.blue, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Ver Detalles',
                            style: TextStyle(color: Colors.white),
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
                          Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
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

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 240, 208, 48),
            ),
          ),
        );
      },
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
            child: Icon(
              Icons.business_center_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay empresas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _searchController.text.isEmpty
                ? 'Presiona + para agregar tu primera empresa'
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

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _navegarARegistrar,
      backgroundColor: const Color.fromARGB(255, 240, 208, 48),
      icon: const Icon(Icons.add_business_rounded),
      label: const Text(
        'Nueva Empresa',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}