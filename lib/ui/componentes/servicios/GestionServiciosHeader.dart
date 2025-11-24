import 'package:flutter/material.dart';

class GestionServiciosHeader extends StatelessWidget {
  final String? empresaNombre;

  const GestionServiciosHeader({
    super.key,
    required this.empresaNombre,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestión de',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  'Servicios - ${empresaNombre ?? 'Empresa'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}