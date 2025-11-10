import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onAgregarServicio;
  final VoidCallback onGuardarTodo;

  const ActionButtonsRow({
    super.key,
    required this.onAgregarServicio,
    required this.onGuardarTodo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAgregarServicio,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Servicio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 208, 48),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onGuardarTodo,
            icon: const Icon(Icons.save),
            label: const Text('Guardar Todo'),
          ),
        ),
      ],
    );
  }
}