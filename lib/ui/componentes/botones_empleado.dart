  import 'package:flutter/material.dart';
  import '../../Models/empleado_model.dart';

  class BotonesEmpleado extends StatelessWidget {
    final Empleado empleado;
    final VoidCallback onEditar;
    final VoidCallback onCambiarEstado;

    const BotonesEmpleado({
      super.key,
      required this.empleado,
      required this.onEditar,
      required this.onCambiarEstado,
    });

    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          // Botón Editar
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onEditar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue.shade700,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue.shade200, width: 1),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text(
                'Editar',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Botón Activar/Desactivar
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onCambiarEstado,
              style: ElevatedButton.styleFrom(
                backgroundColor: empleado.estado 
                    ? Colors.orange.shade50 
                    : Colors.green.shade50,
                foregroundColor: empleado.estado 
                    ? Colors.orange.shade700 
                    : Colors.green.shade700,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: empleado.estado 
                        ? Colors.orange.shade200 
                        : Colors.green.shade200,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              icon: Icon(
                empleado.estado ? Icons.toggle_off : Icons.toggle_on,
                size: 16,
              ),
              label: Text(
                empleado.estado ? 'Desactivar' : 'Activar',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      );
    }
  }
