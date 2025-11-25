import 'package:flutter/material.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Contabilidad.dart';
import 'package:proyecto/controllers/EmpresaController.dart';
import 'package:proyecto/controllers/ContabilidadController.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ✅ DASHBOARD DE GANANCIAS - Todas las empresas del admin
class GananciasEmpresasPage extends StatefulWidget {
  const GananciasEmpresasPage({super.key});

  @override
  State<GananciasEmpresasPage> createState() => _GananciasEmpresasPageState();
}

class _GananciasEmpresasPageState extends State<GananciasEmpresasPage> {
  final EmpresaController _empresaController = EmpresaController();
  final ContabilidadController _contabilidadController = ContabilidadController();

  bool _cargando = true;
  List<Empresa> _empresas = [];
  Map<String, double> _gananciasPorEmpresa = {};
  double _gananciasTotal = 0.0;
  String _periodoSeleccionado = 'Mes'; // Mes, Semana, Año

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');

      if (uid == null) {
        //print('❌ Error: No hay usuario logueado');
        return;
      }

      // ✅ 1. Obtener todas las empresas del usuario
      final empresas = await _empresaController.obtenerEmpresasPorUsuario(uid);
      
      double totalGanancias = 0.0;
      Map<String, double> gananciasPorEmpresa = {};

      // ✅ 2. Para cada empresa, obtener su contabilidad
      for (var empresa in empresas) {
        final contabilidades = await _contabilidadController
            .obtenerContabilidadesPorEmpresa(empresa.Id ?? '');

        // ✅ 3. Sumar ganancias según el período seleccionado
        double gananciaEmpresa = 0.0;
        for (var contabilidad in contabilidades) {
          if (_estaEnPeriodo(contabilidad.Fecha)) {
            gananciaEmpresa += contabilidad.PagoPorDia ?? 0.0;
          }
        }

        gananciasPorEmpresa[empresa.Id ?? ''] = gananciaEmpresa;
        totalGanancias += gananciaEmpresa;
      }

      setState(() {
        _empresas = empresas;
        _gananciasPorEmpresa = gananciasPorEmpresa;
        _gananciasTotal = totalGanancias;
        _cargando = false;
      });

      //print('✅ Ganancias totales: \$$totalGanancias');
    } catch (e) {
      //print('❌ Error cargando ganancias: $e');
      setState(() {
        _cargando = false;
      });
    }
  }

  bool _estaEnPeriodo(DateTime? fecha) {
    if (fecha == null) return false;

    final ahora = DateTime.now();
    switch (_periodoSeleccionado) {
      case 'Semana':
        return ahora.difference(fecha).inDays <= 7;
      case 'Mes':
        return fecha.month == ahora.month && fecha.year == ahora.year;
      case 'Año':
        return fecha.year == ahora.year;
      default:
        return true;
    }
  }

  void _cambiarPeriodo(String periodo) {
    setState(() {
      _periodoSeleccionado = periodo;
    });
    _cargarDatos();
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
              if (_cargando)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 240, 208, 48),
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _cargarDatos,
                    color: const Color.fromARGB(255, 240, 208, 48),
                    backgroundColor: const Color.fromARGB(255, 40, 40, 40),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSelectorPeriodo(),
                          const SizedBox(height: 20),
                          _buildTarjetaGananciasTotal(),
                          const SizedBox(height: 24),
                          _buildEstadisticas(),
                          const SizedBox(height: 24),
                          _buildListaEmpresas(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ganancias',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Dashboard financiero',
                  style: TextStyle(
                    color: Colors.white60,
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

  Widget _buildSelectorPeriodo() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(20, 255, 255, 255),

        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: ['Semana', 'Mes', 'Año'].map((periodo) {
          final seleccionado = _periodoSeleccionado == periodo;
          return Expanded(
            child: GestureDetector(
              onTap: () => _cambiarPeriodo(periodo),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: seleccionado
                      ? const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 240, 208, 48),
                            Color.fromARGB(255, 255, 220, 100),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  periodo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: seleccionado ? Colors.white : Colors.white60,
                    fontWeight:
                        seleccionado ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTarjetaGananciasTotal() {
    return Container(
      padding: const EdgeInsets.all(24),
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
            color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.4),
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
                'Ingresos Totales',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$${_gananciasTotal.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _periodoSeleccionado.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_empresas.length} empresa${_empresas.length != 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticas() {
    final promedioGanancias = _empresas.isNotEmpty 
        ? _gananciasTotal / _empresas.length 
        : 0.0;
    
    final empresaMasProductiva = _gananciasPorEmpresa.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estadísticas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMiniEstadistica(
                'Promedio',
                '\$${promedioGanancias.toStringAsFixed(0)}',
                Icons.show_chart_rounded,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMiniEstadistica(
                'Empresas',
                '${_empresas.length}',
                Icons.business_rounded,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniEstadistica(
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(20, 255, 255, 255),

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
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
                  color: const Color.fromARGB(178, 255, 255, 255),

                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icono, color: color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
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

  Widget _buildListaEmpresas() {
    if (_empresas.isEmpty) {
      return _buildEmptyState();
    }

    // Ordenar por ganancias (mayor a menor)
    final empresasOrdenadas = List<Empresa>.from(_empresas)
      ..sort((a, b) {
        final gananciaA = _gananciasPorEmpresa[a.Id] ?? 0.0;
        final gananciaB = _gananciasPorEmpresa[b.Id] ?? 0.0;
        return gananciaB.compareTo(gananciaA);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Por Empresa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Ranking',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: empresasOrdenadas.length,
          itemBuilder: (context, index) {
            final empresa = empresasOrdenadas[index];
            final ganancia = _gananciasPorEmpresa[empresa.Id] ?? 0.0;
            final porcentaje = _gananciasTotal > 0
                ? (ganancia / _gananciasTotal * 100)
                : 0.0;
            
            return _buildTarjetaEmpresa(
              empresa,
              ganancia,
              porcentaje,
              index + 1,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTarjetaEmpresa(
    Empresa empresa,
    double ganancia,
    double porcentaje,
    int posicion,
  ) {
    Color colorMedalla = Colors.grey;
    if (posicion == 1) colorMedalla = const Color(0xFFFFD700); // Oro
    if (posicion == 2) colorMedalla = const Color(0xFFC0C0C0); // Plata
    if (posicion == 3) colorMedalla = const Color(0xFFCD7F32); // Bronce

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(20, 255, 255, 255),

        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: posicion <= 3
              ? colorMedalla.withOpacity(0.5)
              : Colors.white.withOpacity(0.15),
          width: posicion <= 3 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: posicion <= 3
                      ? LinearGradient(
                          colors: [colorMedalla, colorMedalla.withOpacity(0.7)],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.grey.shade600,
                            Colors.grey.shade800,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: posicion <= 3
                      ? Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.white,
                          size: 22,
                        )
                      : Text(
                          '#$posicion',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      empresa.Nombre ?? 'Sin nombre',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${porcentaje.toStringAsFixed(1)}% del total',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${ganancia.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 240, 208, 48),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _periodoSeleccionado,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: porcentaje / 100,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                posicion <= 3 ? colorMedalla : const Color.fromARGB(255, 240, 208, 48),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
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
            child: const Icon(
              Icons.attach_money_rounded,
              size: 60,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No hay datos de ganancias',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aún no hay registros para el período seleccionado',
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
}