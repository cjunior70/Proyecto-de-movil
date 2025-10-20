import 'package:flutter/material.dart';
import '../../models/servicio_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                servicio.nombre,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Text(
                '\$${servicio.precio.toStringAsFixed(0)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
            Expanded(
              child: Text(
                servicio.duracion,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
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