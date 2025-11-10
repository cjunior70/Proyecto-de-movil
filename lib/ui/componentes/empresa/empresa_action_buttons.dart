import 'package:flutter/material.dart';

class EmpresaActionButtons extends StatelessWidget {
  final VoidCallback onServiciosPressed;
  final VoidCallback onMapaPressed;
  final VoidCallback onLlamarPressed;
  final String telefono;

  const EmpresaActionButtons({
    super.key,
    required this.onServiciosPressed,
    required this.onMapaPressed,
    required this.onLlamarPressed,
    required this.telefono,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton('Servicios', Icons.spa, onServiciosPressed),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton('Mapa', Icons.map, onMapaPressed),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton('Llamar', Icons.phone, onLlamarPressed),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}