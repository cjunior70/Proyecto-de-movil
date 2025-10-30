import 'package:flutter/material.dart';
import '../../Models/Servicio.dart';

class ServicioCard extends StatelessWidget {
  final Servicio servicio;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const ServicioCard({
    super.key,
    required this.servicio,
    required this.onEditar,
    required this.onEliminar,
  });

  // Getter para formatear el tiempo de duración
  String get tiempoFormateado {
    if (servicio.TiempoPromedio == null) return '';
    final minutos = servicio.TiempoPromedio!.inMinutes;
    if (minutos < 60) {
      return '$minutos min';
    } else {
      final horas = minutos ~/ 60;
      final minRestantes = minutos % 60;
      return minRestantes == 0 ? '$horas h' : '$horas h $minRestantes min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Nombre del servicio
            Expanded(
              flex: 2,
              child: Text(
                servicio.Nombre ?? '',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            // Precio del servicio
            Expanded(
              child: Text(
                '\$${servicio.Precio?.toStringAsFixed(0) ?? '0'}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
            // Tiempo promedio del servicio
            Expanded(
              child: Text(
                tiempoFormateado,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            // Botones de editar y eliminar
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: onEditar,
                    color: Colors.blue,
                    tooltip: 'Editar servicio',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18),
                    onPressed: onEliminar,
                    color: Colors.red,
                    tooltip: 'Eliminar servicio',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
