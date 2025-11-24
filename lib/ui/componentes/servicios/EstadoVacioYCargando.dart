import 'package:flutter/material.dart';

class EstadoVacioYCargando extends StatelessWidget {
  final bool isCargando;
  final bool isFiltrando;

  const EstadoVacioYCargando({
    super.key,
    required this.isCargando,
    this.isFiltrando = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCargando) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 240, 208, 48),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando servicios...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Estado Vacío (Sin resultados o lista vacía)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltrando ? Icons.search_off_rounded : Icons.room_service_rounded,
            color: Colors.white.withOpacity(0.3),
            size: 80,
          ),
          const SizedBox(height: 20),
          Text(
            isFiltrando ? 'Sin resultados para la búsqueda.' : 'Aún no hay servicios registrados.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isFiltrando ? 'Intenta con otro término.' : 'Presiona el botón "+" para agregar el primero.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}