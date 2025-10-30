import 'package:flutter/material.dart';

class ServicioHeader extends StatelessWidget {
  final VoidCallback onRefresh;
  final int totalServicios;

  const ServicioHeader({
    super.key,
    required this.onRefresh,
    required this.totalServicios,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Servicios ($totalServicios)',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh,
          tooltip: 'Actualizar servicios',
        ),
      ],
    );
  }
}