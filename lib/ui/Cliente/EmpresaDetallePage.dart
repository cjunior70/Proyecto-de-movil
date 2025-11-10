import 'package:flutter/material.dart';
import 'ServicioEmpleadosPage.dart'; // ✅ Importar la página de empleados

/// ✅ DETALLE DE EMPRESA CON DISEÑO OSCURO
class EmpresaDetallePage extends StatefulWidget {
  final String? empresaId;

  const EmpresaDetallePage({
    super.key,
    this.empresaId,
  });

  @override
  State<EmpresaDetallePage> createState() => _EmpresaDetallePageState();
}

class _EmpresaDetallePageState extends State<EmpresaDetallePage> {
  bool _cargando = true;
  bool _esFavorita = false;

  // ✅ DATOS DE EJEMPLO - Ahora como variable de instancia
  late final Map<String, dynamic> empresa = {
    'id': '1',
    'nombre': 'Barbería Elite',
    'descripcion': 'Los mejores cortes de la ciudad con profesionales capacitados en técnicas modernas',
    'direccion': 'Calle 15 #10-50, Centro',
    'telefono': '3001234567',
    'imagenUrl': 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=800',
    'rating': 4.8,
    'totalReseñas': 124,
    'horario': 'Lun - Sáb: 9:00 AM - 7:00 PM',
  };

  final List<Map<String, dynamic>> servicios = [
    {
      'id': '1',
      'nombre': 'Corte Clásico',
      'descripcion': 'Corte tradicional con máquina y tijera',
      'precio': 25000,
      'duracion': '30 min',
      'icono': Icons.content_cut,
    },
    {
      'id': '2',
      'nombre': 'Barba y Bigote',
      'descripcion': 'Arreglo completo de barba con diseño',
      'precio': 15000,
      'duracion': '20 min',
      'icono': Icons.face,
    },
    {
      'id': '3',
      'nombre': 'Corte Premium',
      'descripcion': 'Corte moderno con lavado y productos',
      'precio': 40000,
      'duracion': '45 min',
      'icono': Icons.star,
    },
    {
      'id': '4',
      'nombre': 'Coloración',
      'descripcion': 'Tinte completo o mechas',
      'precio': 60000,
      'duracion': '90 min',
      'icono': Icons.brush,
    },
  ];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _cargando = false;
    });
  }

  void _toggleFavorito() {
    setState(() {
      _esFavorita = !_esFavorita;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _esFavorita ? '❤️ Agregado a favoritos' : '💔 Removido de favoritos',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: _esFavorita ? Colors.green : Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _seleccionarServicio(Map<String, dynamic> servicio) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicioEmpleadosPage(
          empresaId: widget.empresaId,
          empresa: empresa, // ✅ Pasar datos de la empresa
          servicio: servicio,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 43, 43, 43),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 240, 208, 48),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 43, 43, 43),
                    Color.fromARGB(255, 80, 80, 80),
                  ],
                ),
              ),
              child: Column(
                children: [
                  _buildInfoEmpresa(),
                  const SizedBox(height: 20),
                  _buildSeccionServicios(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildBotonFlotante(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              _esFavorita ? Icons.favorite : Icons.favorite_border,
              color: _esFavorita ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorito,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              empresa['imagenUrl'],
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color.fromARGB(255, 43, 43, 43).withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoEmpresa() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  empresa['nombre'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 240, 208, 48),
                      Color.fromARGB(255, 255, 220, 100),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${empresa['rating']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${empresa['totalReseñas']} reseñas',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 16),
          
          Text(
            empresa['descripcion'],
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildInfoRow(Icons.location_on, empresa['direccion']),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.phone, empresa['telefono']),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.access_time, empresa['horario']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icono, String texto) {
    return Row(
      children: [
        Icon(icono, color: const Color.fromARGB(255, 240, 208, 48), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionServicios() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Servicios Disponibles",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: servicios.length,
            itemBuilder: (context, index) {
              final servicio = servicios[index];
              return _buildTarjetaServicio(servicio);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaServicio(Map<String, dynamic> servicio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _seleccionarServicio(servicio),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 240, 208, 48),
                        Color.fromARGB(255, 255, 220, 100),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    servicio['icono'],
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        servicio['nombre'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        servicio['descripcion'],
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.white38),
                          const SizedBox(width: 4),
                          Text(
                            servicio['duracion'],
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${servicio['precio']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 240, 208, 48),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white38,
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

  Widget _buildBotonFlotante() {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('👆 Selecciona un servicio para continuar'),
              backgroundColor: Colors.grey.shade800,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 240, 208, 48),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "Selecciona un Servicio",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}