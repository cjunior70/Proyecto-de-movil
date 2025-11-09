import 'package:flutter/material.dart';
import 'package:proyecto/ui/Cliente/ClienteDetallePage.dart';
import 'package:proyecto/ui/Cliente/ClienteReservacionesPage.dart';
import 'package:proyecto/ui/Cliente/EmpresaDetallePage.dart';

// Componentes mejorados
import '../componentes/comunes/app_bars/app_bar_home.dart';
import '../componentes/clientes/home/barra_busqueda.dart';
import '../componentes/clientes/home/categorias_home.dart';
import '../componentes/clientes/home/lista_empresas_populares.dart';
import '../componentes/clientes/navegacion/bottom_nav_cliente.dart';

/// ✅ HOME DEL USUARIO - Diseño Oscuro Premium con Componentes Organizados
class UsuarioHome extends StatefulWidget {
  const UsuarioHome({super.key});

  @override
  State<UsuarioHome> createState() => _UsuarioHomeState();
}

class _UsuarioHomeState extends State<UsuarioHome>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controladorBusqueda = TextEditingController();
  int _selectedIndex = 0;
  String? _categoriaSeleccionada;
  bool _cargandoEmpresas = false;
  late AnimationController _animationController;

  // ✅ DATOS DE EJEMPLO - Tu compañero reemplazará con API
  List<dynamic> _empresas = [
    {
      'id': '1',
      'nombre': "Barbería Elite",
      'descripcion': "Cortes modernos y profesionales con estilo",
      'imagenUrl':
          "https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=400",
      'rating': 4.8,
      'categoria': 'corte',
    },
    {
      'id': '2',
      'nombre': "Spa Relax",
      'descripcion': "Belleza y bienestar integral para ti",
      'imagenUrl':
          "https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400",
      'rating': 4.5,
      'categoria': 'facial',
    },
    {
      'id': '3',
      'nombre': "Salón Colors",
      'descripcion': "Expertos en coloración y tratamientos",
      'imagenUrl':
          "https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400",
      'rating': 4.7,
      'categoria': 'coloracion',
    },
  ];

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

  // ✅ MÉTODO QUE TU COMPAÑERO REEMPLAZARÁ CON API
  void _cargarEmpresasIniciales() {
    setState(() {
      _cargandoEmpresas = true;
    });

    // Simular carga de API
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _cargandoEmpresas = false;
          // _empresas = await EmpresaService.obtenerEmpresasPopulares();
        });
      }
    });
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
        _cargarEmpresasIniciales();
      } else {
        _categoriaSeleccionada = categoriaId;
        // Filtrar empresas por categoría
        // En el futuro: _empresas = await EmpresaService.filtrarPorCategoria(categoriaId);
      }
    });
  }

  void _onBuscar(String query) {
    if (query.isEmpty) {
      _cargarEmpresasIniciales();
      return;
    }
    // En el futuro: _empresas = await EmpresaService.buscar(query);
  }

  void _onEmpresaSeleccionada(dynamic empresa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpresaDetallePage(empresaId: empresa['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ FONDO OSCURO DEGRADADO PREMIUM
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
              // ✅ APP BAR COMPONENTE
              FadeTransition(
                opacity: _animationController,
                child: AppBarHome(
                  titulo: "Estilo Ideal",
                  subtitulo: "Encuentra tu",
                  onNotificacionPresionada: () {
                    // TODO: Implementar notificaciones
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Notificaciones'),
                        backgroundColor: Colors.white.withOpacity(0.1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  contadorNotificaciones: 3,
                ),
              ),

              // ✅ CONTENIDO SCROLLABLE CON ANIMACIONES
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

                        // ✅ BARRA DE BÚSQUEDA
                        BarraBusqueda(
                          controlador: _controladorBusqueda,
                          onChanged: _onBuscar,
                        ),
                        const SizedBox(height: 28),

                        // ✅ CATEGORÍAS
                        CategoriasHome(
                          onVerTodas: () {
                            // TODO: Navegar a todas las categorías
                          },
                          onCategoriaSeleccionada: _onCategoriaSeleccionada,
                          categoriaSeleccionada: _categoriaSeleccionada,
                        ),
                        const SizedBox(height: 28),

                        // ✅ EMPRESAS POPULARES
                        ListaEmpresasPopulares(
                          empresas: _empresas,
                          cargando: _cargandoEmpresas,
                          onVerTodas: () {
                            // TODO: Navegar a lista completa
                          },
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

      // ✅ BOTTOM NAVIGATION COMPONENTE
      bottomNavigationBar: BottomNavCliente(
        indiceSeleccionado: _selectedIndex,
        onItemTapped: _onNavTapped,
      ),
    );
  }
}