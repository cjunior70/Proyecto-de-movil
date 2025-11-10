import 'package:flutter/material.dart';

/// ✅ AppBar personalizado con diseño oscuro premium y botón de cerrar sesión
class AppBarHome extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final VoidCallback? onCerrarSesionPresionado;
  final bool mostrarCerrarSesion;

  const AppBarHome({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.onCerrarSesionPresionado,
    this.mostrarCerrarSesion = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ Sección de título
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (subtitulo != null)
                  Text(
                    subtitulo!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ✅ Botón de cerrar sesión mejorado
          if (mostrarCerrarSesion) _buildBotonCerrarSesion(),
        ],
      ),
    );
  }

  Widget _buildBotonCerrarSesion() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onCerrarSesionPresionado,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.logout_rounded,
              color: const Color.fromARGB(255, 240, 208, 48), // Mismo color dorado
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}