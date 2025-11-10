import 'package:flutter/material.dart';

class DialogoEleccionRegistro extends StatelessWidget {
  final VoidCallback alPresionarAdministrador;
  final VoidCallback alPresionarCliente;

  const DialogoEleccionRegistro({
    super.key,
    required this.alPresionarAdministrador,
    required this.alPresionarCliente,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono y título
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6B4E71).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Color(0xFF6B4E71),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            
            const Text(
              "Crear Cuenta",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4E71),
              ),
            ),
            const SizedBox(height: 8),
            
            const Text(
              "Selecciona el tipo de cuenta que deseas crear",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            
            // Botones de opción
            Column(
              children: [
                _BotonRegistro(
                  icono: Icons.business_center_rounded,
                  titulo: "Soy Empresa",
                  subtitulo: "Administra tu centro de estética",
                  color: Colors.blueAccent,
                  onPressed: alPresionarAdministrador,
                ),
                const SizedBox(height: 12),
                _BotonRegistro(
                  icono: Icons.person_rounded,
                  titulo: "Soy Cliente",
                  subtitulo: "Busco servicios de estética",
                  color: Colors.green,
                  onPressed: alPresionarCliente,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Enlace cancelar
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonRegistro extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final Color color;
  final VoidCallback onPressed;

  const _BotonRegistro({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icono, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitulo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}