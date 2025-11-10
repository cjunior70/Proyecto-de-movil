import 'package:flutter/material.dart';

class TarjetaCategoria extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color colorIcono;
  final VoidCallback? onTap;
  final bool seleccionada;

  const TarjetaCategoria({
    super.key,
    required this.titulo,
    required this.icono,
    this.colorIcono = Colors.orange,
    this.onTap,
    this.seleccionada = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Tamaño fijo para evitar overflow
        height: 100, // Altura fija para consistencia
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: seleccionada ? colorIcono.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: seleccionada ? colorIcono : Colors.grey.shade200,
            width: seleccionada ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorIcono.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icono, color: colorIcono, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11, // Texto más pequeño
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              maxLines: 2, // Máximo 2 líneas
              overflow: TextOverflow.ellipsis, // Puntos si es muy largo
            ),
          ],
        ),
      ),
    );
  }
}