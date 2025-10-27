import 'package:flutter/material.dart';
import '../../models/empleado_model.dart';
import 'botones_empleado.dart';

class EmpleadoCard extends StatelessWidget {
  final Empleado empleado;
  final VoidCallback onEditar;
  final VoidCallback onCambiarEstado;
  final int index;

  const EmpleadoCard({
    super.key,
    required this.empleado,
    required this.onEditar,
    required this.onCambiarEstado,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildContactInfo(),
            const SizedBox(height: 12),
            BotonesEmpleado(
              empleado: empleado,
              onEditar: onEditar,
              onCambiarEstado: onCambiarEstado,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar del empleado
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 240, 208, 48),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: const Color.fromARGB(255, 240, 208, 48),
            size: 30,
          ),
        ),
        const SizedBox(width: 16),
        
        // Información del empleado
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                empleado.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                empleado.cargo,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              _buildEstadoBadge(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEstadoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: empleado.estado 
            ? Colors.green
            : Colors.red,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: empleado.estado ? Colors.green : Colors.red,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            empleado.estado ? Icons.check_circle : Icons.remove_circle,
            size: 14,
            color: empleado.estado ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Text(
            empleado.estado ? 'ACTIVADO' : 'DESACTIVADO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: empleado.estado ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Row(
      children: [
        Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          empleado.telefono,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 16),
        Icon(Icons.email, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            empleado.email,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}