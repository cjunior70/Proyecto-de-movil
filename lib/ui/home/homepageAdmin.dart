import 'package:flutter/material.dart';
import 'package:proyecto/ui/Administrador/ListaEmpresas.dart';
import 'package:proyecto/ui/Administrador/UsuarioDetallePage.dart';
import 'package:proyecto/ui/Administrador/GananciasEmpresasPage.dart';
import 'package:proyecto/controllers/EmpresaController.dart';
import 'package:proyecto/controllers/ContabilidadController.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ✅ HOMEPAGE ADMINISTRADOR - MEJORADO CON DATOS REALES
class HomepageAdmin extends StatefulWidget {
  const HomepageAdmin({super.key});

  @override
  State<HomepageAdmin> createState() => _HomepageAdminState();
}

class _HomepageAdminState extends State<HomepageAdmin> {
  final EmpresaController _empresaController = EmpresaController();
  final ContabilidadController _contabilidadController = ContabilidadController();

  bool _cargando = true;
  Map<String, dynamic> _estadisticas = {
    'totalEmpresas': 0,
    'gananciasTotal': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _cargarEstadisticas();
  }

  Future<void> _cargarEstadisticas() async {
    setState(() {
      _cargando = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');

      if (uid == null) {
        print('❌ Error: No hay usuario logueado');
        return;
      }

      // ✅ Obtener empresas del usuario
      final empresas = await _empresaController.obtenerEmpresasPorUsuario(uid);

      // ✅ Calcular ganancias totales del mes actual
      double gananciasTotal = 0.0;
      final ahora = DateTime.now();

      for (var empresa in empresas) {
        final contabilidades = await _contabilidadController
            .obtenerContabilidadesPorEmpresa(empresa.Id ?? '');

        for (var contabilidad in contabilidades) {
          // Solo contar ganancias del mes actual
          if (contabilidad.Fecha != null &&
              contabilidad.Fecha!.month == ahora.month &&
              contabilidad.Fecha!.year == ahora.year) {
            gananciasTotal += contabilidad.PagoPorDia ?? 0.0;
          }
        }
      }

      setState(() {
        _estadisticas = {
          'totalEmpresas': empresas.length,
          'gananciasTotal': gananciasTotal,
        };
        _cargando = false;
      });

      print('✅ Estadísticas cargadas: $_estadisticas');
    } catch (e) {
      print('❌ Error cargando estadísticas: $e');
      setState(() {
        _cargando = false;
      });
    }
  }

  final List<Map<String, dynamic>> _actividadReciente = [
    {
      'titulo': 'Nueva Empresa',
      'descripcion': 'Barbería "Estilo Moderno"',
      'tiempo': 'Hace 2h',
      'icono': Icons.business_rounded,
      'color': Color.fromARGB(255, 240, 208, 48),
    },
    {
      'titulo': 'Empleado Asignado',
      'descripcion': 'Juan Pérez - Spa Relax',
      'tiempo': 'Hace 5h',
      'icono': Icons.person_add_rounded,
      'color': Colors.blue,
    },
    {
      'titulo': 'Reserva Completada',
      'descripcion': '10 servicios finalizados',
      'tiempo': 'Hace 1d',
      'icono': Icons.check_circle_rounded,
      'color': Colors.green,
    },
  ];

  void _navegarA(String ruta) {
    Widget? destino;

    switch (ruta) {
      case 'empresas':
        destino = const ListaEmpresas();
        break;
      case 'perfil':
        destino = const Usuariodetallepage();
        break;
      case 'ganancias':
        destino = const GananciasEmpresasPage();
        break;
    }

    if (destino != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destino!),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ir a: $ruta'),
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

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
            border: Border.all(color: Colors.white.withAlpha((0.1 * 255).round())),
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
                'Tu sesión será cerrada',
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
                        side: BorderSide(color: Colors.white.withAlpha((0.1*255).round())),
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
          child: _cargando
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 240, 208, 48),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarEstadisticas,
                  color: const Color.fromARGB(255, 240, 208, 48),
                  backgroundColor: const Color.fromARGB(255, 40, 40, 40),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildTarjetaGanancias(),
                        const SizedBox(height: 16),
                        _buildEstadisticas(),
                        const SizedBox(height: 24),
                        _buildAccesosRapidos(),
                        const SizedBox(height: 24),
                        _buildActividadReciente(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 240, 208, 48).withAlpha((0.3 * 255).round()),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.admin_panel_settings_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Panel Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Gestiona tu negocio',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withAlpha((0.2 * 255).round()),
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
            onPressed: _cerrarSesion,
            tooltip: 'Salir',
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  Widget _buildTarjetaGanancias() {
    return GestureDetector(
      onTap: () => _navegarA('ganancias'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 208, 48),
              Color.fromARGB(255, 255, 220, 100),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 240, 208, 48).withAlpha((0.4 * 255).round()),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ganancias del Mes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                   color: Colors.white.withAlpha((0.3 * 255).round()),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '\$${_estadisticas['gananciasTotal'].toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Ver detalle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadisticas() {
    return Row(
      children: [
        Expanded(
          child: _buildTarjetaEstadistica(
            'Empresas',
            '${_estadisticas['totalEmpresas']}',
            Icons.business_rounded,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTarjetaEstadistica(
            'Promedio',
            _estadisticas['totalEmpresas'] > 0
                ? '\$${(_estadisticas['gananciasTotal'] / _estadisticas['totalEmpresas']).toStringAsFixed(0)}'
                : '\$0',
            Icons.show_chart_rounded,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildTarjetaEstadistica(
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
       color: Colors.white.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha((0.15 * 255).round())),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  color: Colors.white.withAlpha((0.7 * 255).round()),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                 color: color.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icono, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccesosRapidos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acciones',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildTarjetaAcceso(
          'Empresas',
          'Administrar empresas',
          Icons.business_rounded,
          const Color.fromARGB(255, 240, 208, 48),
          () => _navegarA('empresas'),
        ),
        const SizedBox(height: 10),
        _buildTarjetaAcceso(
          'Mi Perfil',
          'Ver información personal',
          Icons.person_rounded,
          Colors.teal,
          () => _navegarA('perfil'),
        ),
      ],
    );
  }

  Widget _buildTarjetaAcceso(
    String titulo,
    String descripcion,
    IconData icono,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha((0.15 * 255).round())),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                  color: color.withAlpha((0.2 * 255).round()),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icono,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        descripcion,
                        style: TextStyle(
                        color: Colors.white.withAlpha((0.6 * 255).round()),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withAlpha((0.4 * 255).round()),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActividadReciente() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Actividad',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            GestureDetector(
              onTap: () => _navegarA('historial'),
              child: const Text(
                'Ver más',
                style: TextStyle(
                  color: Color.fromARGB(255, 240, 208, 48),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.08 * 255).round()),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withAlpha((0.15 * 255).round())),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _actividadReciente.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withAlpha((0.1 * 255).round()),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final actividad = _actividadReciente[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                dense: true,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: actividad['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    actividad['icono'],
                    color: actividad['color'],
                    size: 20,
                  ),
                ),
                title: Text(
                  actividad['titulo'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text(
                  actividad['descripcion'],
                  style: TextStyle(
                    color: Colors.white.withAlpha((0.6 * 255).round()),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  actividad['tiempo'],
                  style: TextStyle(
                     color: Colors.white.withAlpha((0.5 * 255).round()),
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}