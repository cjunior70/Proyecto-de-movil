import 'package:flutter/material.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/controllers/ServiciosController.dart';
import 'ServicioEmpleadosPage.dart';

/// ✅ DETALLE DE EMPRESA CON DATOS REALES DE SUPABASE
class EmpresaDetallePage extends StatefulWidget {
  final Empresa empresa; // ✅ Recibe el objeto Empresa directamente

  const EmpresaDetallePage({
    super.key,
    required this.empresa,
  });

  @override
  State<EmpresaDetallePage> createState() => _EmpresaDetallePageState();
}

class _EmpresaDetallePageState extends State<EmpresaDetallePage> {
  bool _cargando = true;
  bool _esFavorita = false;
  List<Servicio> _servicios = [];
  
  final ServicioController _servicioController = ServicioController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    try {
      // ✅ Cargar servicios de la empresa desde Supabase
      final servicios = await _servicioController
          .obtenerTodasServiciosPorEmpresa(widget.empresa.Id ?? '');
      
      setState(() {
        _servicios = servicios;
        _cargando = false;
      });
    } catch (e) {
      //print('❌ Error cargando servicios: $e');
      setState(() {
        _cargando = false;
      });
    }
  }

  void _toggleFavorito() {
    setState(() {
      _esFavorita = !_esFavorita;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _esFavorita ? '❤ Agregado a favoritos' : '💔 Removido de favoritos',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: _esFavorita ? Colors.green : Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _seleccionarServicio(Servicio servicio) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicioEmpleadosPage(
          empresa: widget.empresa, // ✅ Objeto Empresa completo
          servicio: servicio,       // ✅ Objeto Servicio completo
        ),
      ),
    );
  }

  String _formatearHorario() {
    final inicio = widget.empresa.formatTime(widget.empresa.ComienzoLaboral);
    final fin = widget.empresa.formatTime(widget.empresa.FinalizacionLaboral);
    return 'Lun - Sáb: $inicio - $fin';
  }

  String _formatearDuracion(Duration duracion) {
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60);
    
    if (horas > 0) {
      return '$horas h ${minutos > 0 ? "$minutos min" : ""}';
    }
    return '$minutos min';
  }

  // ✅ Asignar ícono según el nombre del servicio
  IconData _obtenerIconoServicio(String nombre) {
    final nombreLower = nombre.toLowerCase();
    
    if (nombreLower.contains('corte') || nombreLower.contains('cabello')) {
      return Icons.content_cut;
    } else if (nombreLower.contains('barba') || nombreLower.contains('bigote')) {
      return Icons.face;
    } else if (nombreLower.contains('color') || nombreLower.contains('tinte')) {
      return Icons.brush;
    } else if (nombreLower.contains('premium') || nombreLower.contains('vip')) {
      return Icons.star;
    } else if (nombreLower.contains('uña') || nombreLower.contains('manicure')) {
      return Icons.back_hand;
    } else if (nombreLower.contains('masaje')) {
      return Icons.spa;
    }
    
    return Icons.miscellaneous_services;
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
      floatingActionButton: _servicios.isNotEmpty ? _buildBotonFlotante() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSliverAppBar() {
    final imagenUrl = widget.empresa.getImagenGeneralUrl() ?? 
                      widget.empresa.getImagenMiniaturaUrl() ??
                      'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=800';

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
              imagenUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade800,
                  child: const Icon(
                    Icons.business,
                    size: 80,
                    color: Colors.white38,
                  ),
                );
              },
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
                  widget.empresa.Nombre ?? 'Sin nombre',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (widget.empresa.Estrellas != null && widget.empresa.Estrellas! > 0)
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
                        '${widget.empresa.Estrellas!.toStringAsFixed(1)}',
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
          const SizedBox(height: 16),
          
          if (widget.empresa.DescripcionUbicacion != null)
            Text(
              widget.empresa.DescripcionUbicacion!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          
          const SizedBox(height: 20),
          
          if (widget.empresa.DescripcionUbicacion != null)
            _buildInfoRow(Icons.location_on, widget.empresa.DescripcionUbicacion!),
          
          if (widget.empresa.WhatsApp != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, widget.empresa.WhatsApp!),
          ],
          
          if (widget.empresa.Correo != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, widget.empresa.Correo!),
          ],
          
          const SizedBox(height: 8),
          _buildInfoRow(Icons.access_time, _formatearHorario()),
          
          // Redes sociales
          if (widget.empresa.Facebook != null || 
              widget.empresa.Instagram != null) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),
            Row(
              children: [
                if (widget.empresa.Facebook != null) ...[
                  Icon(Icons.facebook, color: Colors.blue.shade300, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.empresa.Facebook!,
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                if (widget.empresa.Instagram != null) ...[
                  if (widget.empresa.Facebook != null) const SizedBox(width: 16),
                  Icon(Icons.camera_alt, color: Colors.pink.shade300, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.empresa.Instagram!,
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
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
          
          if (_servicios.isEmpty)
            _buildListaVacia()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _servicios.length,
              itemBuilder: (context, index) {
                final servicio = _servicios[index];
                return _buildTarjetaServicio(servicio);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildListaVacia() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.content_cut,
              color: Colors.white38,
              size: 50,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No hay servicios disponibles",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Esta empresa aún no ha agregado servicios",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaServicio(Servicio servicio) {
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
                    _obtenerIconoServicio(servicio.Nombre ?? ''),
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
                        servicio.Nombre ?? 'Sin nombre',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (servicio.Descripcion != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          servicio.Descripcion!,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.white38),
                          const SizedBox(width: 4),
                          Text(
                            _formatearDuracion(servicio.TiempoPromedio),
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
                      '\$${servicio.Precio?.toStringAsFixed(0) ?? '0'}',
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