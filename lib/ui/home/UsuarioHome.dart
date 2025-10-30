import 'package:flutter/material.dart';
import 'package:proyecto/ui/Cliente/ClienteDetallePage.dart';
import 'package:proyecto/ui/Cliente/ClienteReservacionesPage.dart';

// Componentes
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

class _UsuarioHomeState extends State<UsuarioHome> {
  final TextEditingController _controladorBusqueda = TextEditingController();
  int _selectedIndex = 0;
  String? _categoriaSeleccionada;
  bool _cargandoEmpresas = false;

  // ✅ DATOS DE EJEMPLO - Tu compañero reemplazará esto con API
  List<dynamic> _empresas = [
    {
      'id': '1',
      'nombre': "Barbería Elite", 
      'descripcion': "Cortes modernos",
      'imagenUrl': "https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=400",
      'rating': 4.8,
      'categoria': 'corte',
    },
    {
      'id': '2',
      'nombre': "Spa Relax",
      'descripcion': "Belleza integral", 
      'imagenUrl': "https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400",
      'rating': 4.5,
      'categoria': 'facial',
    },
  ];

  @override
  void initState() {
    super.initState();
    _cargarEmpresasIniciales();
  }

  // ✅ MÉTODO QUE TU COMPAÑERO REEMPLAZARÁ CON LLAMADA API
  void _cargarEmpresasIniciales() {
    setState(() {
      _cargandoEmpresas = true;
    });

    // Simular carga de API
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _cargandoEmpresas = false;
        // _empresas = await EmpresaService.obtenerEmpresasPopulares();
      });
    });
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ClienteReservacionesPage()),
      );
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ClienteDetallePage()),
      );
    }
  }

  // ✅ FILTRADO - Tu compañero puede hacer esto en el backend
  void _onCategoriaSeleccionada(String categoriaId) {
    setState(() {
      _categoriaSeleccionada = categoriaId;
    });
    
    // Ejemplo de filtrado local (backend sería mejor)
    final empresasFiltradas = _empresas.where((empresa) {
      return empresa['categoria'] == categoriaId;
    }).toList();
    
    // En el futuro: _empresas = await EmpresaService.filtrarPorCategoria(categoriaId);
  }

  // ✅ BUSQUEDA - Tu compañero implementará búsqueda en API
  void _onBuscar(String query) {
    if (query.isEmpty) {
      _cargarEmpresasIniciales();
      return;
    }
    
    // Ejemplo de búsqueda local
    final resultados = _empresas.where((empresa) {
      return empresa['nombre'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    
    // En el futuro: _empresas = await EmpresaService.buscar(query);
  }

  // ✅ NAVEGACIÓN A DETALLE - Tu compañero pasará el ID real
  void _onEmpresaSeleccionada(dynamic empresa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteDetallePage(
          // ✅ Tu compañero usará empresa.id
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBarHome(
        titulo: "Encuentra tu estilo ideal",
        onNotificacionPresionada: () {
          // TODO: Tu compañero implementará notificaciones
        },
      ),
      body: SafeArea( // ✅ EVITA OVERFLOW EN PANTALLA
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ✅ PADDING CONSISTENTE
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BarraBusqueda(
                controlador: _controladorBusqueda,
                onChanged: _onBuscar,
              ),
              const SizedBox(height: 20),
              CategoriasHome(
                onVerTodas: () {
                  // TODO: Navegar a página de categorías
                },
                onCategoriaSeleccionada: _onCategoriaSeleccionada,
                categoriaSeleccionada: _categoriaSeleccionada,
              ),
              const SizedBox(height: 20),
              ListaEmpresasPopulares(
                empresas: _empresas,
                cargando: _cargandoEmpresas,
                onVerTodas: () {
                  // TODO: Navegar a lista completa
                },
                onEmpresaSeleccionada: _onEmpresaSeleccionada,
              ),
              const SizedBox(height: 20), // ✅ ESPACIO EXTRA AL FINAL
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