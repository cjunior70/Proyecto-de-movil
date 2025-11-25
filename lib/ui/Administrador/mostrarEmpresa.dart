import 'package:flutter/material.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/ui/Administrador/DetallesEmpresaPage.dart';
import 'package:proyecto/ui/Administrador/gestionEmpleados.dart';
import 'package:proyecto/ui/Administrador/gestionServicios.dart';

/// ✅ MOSTRAR EMPRESA - Diseño Oscuro Premium con Tabs
class MostrarEmpresa extends StatefulWidget {
  final Empresa empresa;

  const MostrarEmpresa({super.key, required this.empresa});

  @override
  State<MostrarEmpresa> createState() => _MostrarEmpresaState();
}

class _MostrarEmpresaState extends State<MostrarEmpresa>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Datos de ejemplo para estadísticas
  final Map<String, dynamic> _estadisticas = {
    'empleados': 8,
    'servicios': 15,
    'reservasHoy': 12,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              _buildEmpresaCard(),
              _buildEstadisticas(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabInformacion(),
                    _buildTabServicios(),
                    _buildTabEmpleados(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ HEADER
  Widget _buildHeader() {
    return Padding(
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
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalles de',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Empresa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
              onPressed: _editarEmpresa,
              tooltip: 'Editar',
            ),
          ),
        ],
      ),
    );
  }

  // ✅ TARJETA DE EMPRESA
  Widget _buildEmpresaCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(20, 255, 255, 255),

        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
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
                  color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.business_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.empresa.Nombre!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        color: Colors.white.withOpacity(0.6), size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.empresa.DescripcionUbicacion!,
                        style: TextStyle(
                          color: const Color.fromARGB(178, 255, 255, 255),

                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Row(
                //   children: [
                //     const Icon(Icons.star_rounded,
                //         color: Color.fromARGB(255, 240, 208, 48), size: 18),
                //     const SizedBox(width: 4),
                //     Text(
                //       widget.empresa.ratingPromedio.toStringAsFixed(1),
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 14,
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     Icon(Icons.reviews_rounded,
                //         color: Colors.white.withOpacity(0.5), size: 16),
                //     const SizedBox(width: 4),
                //     Text(
                //       '${widget.empresa.totalReviews} reviews',
                //       style: TextStyle(
                //         color: const Color.fromARGB(178, 255, 255, 255),

                //         fontSize: 13,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ ESTADÍSTICAS
  Widget _buildEstadisticas() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(20, 255, 255, 255),

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEstadisticaItem(
            Icons.people_rounded,
            '${_estadisticas['empleados']}',
            'Empleados',
            Colors.blue,
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color.fromARGB(51, 255, 255, 255),

          ),
          _buildEstadisticaItem(
            Icons.room_service_rounded,
            '${_estadisticas['servicios']}',
            'Servicios',
            Colors.purple,
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color.fromARGB(51, 255, 255, 255),

          ),
          _buildEstadisticaItem(
            Icons.calendar_today_rounded,
            '${_estadisticas['reservasHoy']}',
            'Hoy',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticaItem(
    IconData icono,
    String valor,
    String titulo,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icono, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          titulo,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ✅ TAB BAR
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(20, 255, 255, 255),

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 208, 48),
              Color.fromARGB(255, 255, 220, 100),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Información'),
          Tab(text: 'Servicios'),
          Tab(text: 'Empleados'),
        ],
      ),
    );
  }

  // ✅ TAB 1: INFORMACIÓN
 Widget _buildTabInformacion() {
  final redes = [
    if (widget.empresa.WhatsApp != null && widget.empresa.WhatsApp!.isNotEmpty)
      widget.empresa.WhatsApp!,
    if (widget.empresa.Facebook != null && widget.empresa.Facebook!.isNotEmpty)
      widget.empresa.Facebook!,
    if (widget.empresa.Instagram != null && widget.empresa.Instagram!.isNotEmpty)
      widget.empresa.Instagram!,
  ];

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSeccion(
          'Contacto',
          Icons.contact_phone_rounded,
          [
            _buildInfoRow(Icons.email_rounded, 'Email', widget.empresa.Correo!),
            _buildInfoRow(
                Icons.location_on_rounded, 'Dirección', widget.empresa.DescripcionUbicacion!),
          ],
        ),
        const SizedBox(height: 16),
        _buildSeccion(
          'Descripción',
          Icons.description_rounded,
          [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.empresa.DescripcionUbicacion!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Sección de Redes Sociales
        if (redes.isNotEmpty)
          _buildSeccion(
            'Redes Sociales',
            Icons.share_rounded,
            redes.map((red) => _buildSocialChip(red)).toList(),
          ),
      ],
    ),
  );
}


  // ✅ TAB 2: SERVICIOS
  Widget _buildTabServicios() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.room_service_rounded,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Gestión de Servicios',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Administra los servicios de esta empresa',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GestionServicios(empresa: widget.empresa),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 208, 48),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            label: const Text(
              'Ir a Servicios',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ TAB 3: EMPLEADOS
  Widget _buildTabEmpleados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_rounded,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Gestión de Empleados',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Administra el equipo de esta empresa',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GestionEmpleados(empresa: widget.empresa),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 208, 48),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            label: const Text(
              'Ir a Empleados',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ WIDGETS AUXILIARES
  Widget _buildSeccion(String titulo, IconData icono, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(20, 255, 255, 255),

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icono,
                    color: const Color.fromARGB(255, 240, 208, 48),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icono, color: Colors.white.withOpacity(0.6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valor,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialChip(String red) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.link_rounded, color: Color.fromARGB(255, 240, 208, 48), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              red,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ ACCIONES
  void _editarEmpresa() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetallesEmpresaPage(
          empresa: widget.empresa,  // 👈 pasamos la empresa actual
        ),
      ),
    );
  }

}