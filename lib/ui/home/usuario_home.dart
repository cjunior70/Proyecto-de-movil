import 'package:flutter/material.dart';
import 'package:proyecto/Controllers/EmpresaController.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/ui/Cliente/ClienteDetallePage.dart';
import 'package:proyecto/ui/Cliente/ClienteReservacionesPage.dart';
import 'package:proyecto/ui/Cliente/EmpresaDetallePage.dart';

// Componentes mejorados
import '../componentes/comunes/app_bars/app_bar_home.dart';
import '../componentes/clientes/home/barra_busqueda.dart';
import '../componentes/clientes/home/categorias_home.dart';
import '../componentes/clientes/home/lista_empresas_populares.dart';
import '../componentes/clientes/navegacion/bottom_nav_cliente.dart';

class UsuarioHome extends StatefulWidget {
  const UsuarioHome({super.key});


  @override
  State<UsuarioHome> createState() => _UsuarioHomeState();
}

class _UsuarioHomeState extends State<UsuarioHome>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controladorBusqueda = TextEditingController();
  final EmpresaController _empresaController = EmpresaController();
  
  int _selectedIndex = 0;
  String? _categoriaSeleccionada;
  bool _cargandoEmpresas = false;
  late AnimationController _animationController;

  // ✅ Lista de empresas real desde el controlador
  List<Empresa> _empresas = [];
  List<Empresa> _empresasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cargarEmpresasIniciales();
    _animationController.forward();
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ✅ MÉTODO QUE CARGA EMPRESAS DESDE EL CONTROLLER
  Future<void> _cargarEmpresasIniciales() async {
    setState(() {
      _cargandoEmpresas = true;
    });

    try {
      final empresas = await _empresaController.obtenerTodasEmpresas();
      
      if (mounted) {
        setState(() {
          _empresas = empresas;
          _empresasFiltradas = empresas;
          _cargandoEmpresas = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cargandoEmpresas = false;
        });
      }
    }
  }

  // ✅ MÉTODO CERRAR SESIÓN
  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
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
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Cerrar Sesión?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu sesión será cerrada y deberás iniciar sesión nuevamente',
                textAlign: TextAlign.center,
                style: TextStyle(
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
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // ✅ Limpiar caché al cerrar sesión
                        ;
                        Navigator.pop(context);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Salir',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ClienteReservacionesPage()),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ClienteDetallePage()),
      );
    }
  }

  void _onCategoriaSeleccionada(String categoriaId) {
    setState(() {
      if (_categoriaSeleccionada == categoriaId) {
        _categoriaSeleccionada = null;
        _empresasFiltradas = _empresas;
      } else {
        _categoriaSeleccionada = categoriaId;
        // ✅ Filtrar empresas por categoría (ajusta según tu lógica)
        _empresasFiltradas = _empresas.where((empresa) {
          // Implementa tu lógica de filtrado
          // Por ejemplo, si tienes una lista de servicios con categorías
          return true; // Placeholder
        }).toList();
      }
    });
  }

  void _onBuscar(String query) {
    setState(() {
      if (query.isEmpty) {
        _empresasFiltradas = _empresas;
      } else {
        _empresasFiltradas = _empresas.where((empresa) {
          final nombre = empresa.Nombre?.toLowerCase() ?? '';
          final descripcion = empresa.DescripcionUbicacion?.toLowerCase() ?? '';
          final busqueda = query.toLowerCase();
          return nombre.contains(busqueda) || descripcion.contains(busqueda);
        }).toList();
      }
    });
  }

  void _onEmpresaSeleccionada(Empresa empresa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpresaDetallePage(empresa: empresa ),
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
              FadeTransition(
                opacity: _animationController,
                child: AppBarHome(
                  titulo: "Estilo Ideal",
                  subtitulo: "Encuentra tu estilo perfecto",
                  onCerrarSesionPresionado: _cerrarSesion,
                  mostrarCerrarSesion: true,
                ),
              ),

              Expanded(
                child: FadeTransition(
                  opacity: _animationController,
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        BarraBusqueda(
                          controlador: _controladorBusqueda,
                          onChanged: _onBuscar,
                        ),
                        const SizedBox(height: 28),

                        CategoriasHome(
                          onVerTodas: () {},
                          onCategoriaSeleccionada: _onCategoriaSeleccionada,
                          categoriaSeleccionada: _categoriaSeleccionada,
                        ),
                        const SizedBox(height: 28),

                        // ✅ Pasar empresas reales al componente
                        ListaEmpresasPopulares(
                          empresas: _empresasFiltradas,
                          cargando: _cargandoEmpresas,
                          onVerTodas: () {},
                          onEmpresaSeleccionada: _onEmpresaSeleccionada,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavCliente(
        indiceSeleccionado: _selectedIndex,
        onItemTapped: _onNavTapped,
      ),
    );
  }
}