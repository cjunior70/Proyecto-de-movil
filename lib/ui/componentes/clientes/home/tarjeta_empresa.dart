import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// ✅ Tarjeta de empresa con diseño oscuro premium y animaciones
class TarjetaEmpresa extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final double rating;
  final VoidCallback? onTap;

  const TarjetaEmpresa({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    required this.rating,
    this.onTap,
  });

  @override
  State<TarjetaEmpresa> createState() => _TarjetaEmpresaState();
}

class _TarjetaEmpresaState extends State<TarjetaEmpresa>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(20, 255, 255, 255),

            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: _isPressed ? 0 : 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ IMAGEN CON OVERLAY Y RATING
              _buildImagenEmpresa(),

              // ✅ INFORMACIÓN DE LA EMPRESA
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre
                    Text(
                      widget.nombre,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Descripción
                    Text(
                      widget.descripcion,
                      style: TextStyle(
                        color: const Color.fromARGB(178, 255, 255, 255),

                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Rating con estrellas
                    _buildRatingBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagenEmpresa() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Stack(
        children: [
          // Imagen
          CachedNetworkImage(
            imageUrl: widget.imagenUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 240, 208, 48),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_rounded,
                    color: Colors.white.withOpacity(0.3),
                    size: 60,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Imagen no disponible",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Overlay gradiente sutil
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Badge de rating mejorado
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color.fromARGB(255, 240, 208, 48),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar() {
    return Row(
      children: [
        // Estrellas
        ...List.generate(5, (index) {
          if (index < widget.rating.floor()) {
            // Estrella completa
            return const Icon(
              Icons.star_rounded,
              color: Color.fromARGB(255, 240, 208, 48),
              size: 18,
            );
          } else if (index < widget.rating) {
            // Media estrella
            return const Icon(
              Icons.star_half_rounded,
              color: Color.fromARGB(255, 240, 208, 48),
              size: 18,
            );
          } else {
            // Estrella vacía
            return Icon(
              Icons.star_outline_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 18,
            );
          }
        }),
        const SizedBox(width: 8),
        Text(
          '(${widget.rating.toStringAsFixed(1)})',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}