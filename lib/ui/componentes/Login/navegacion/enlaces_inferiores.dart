import 'package:flutter/material.dart';

class EnlacesInferiores extends StatelessWidget {
  final VoidCallback alPresionarRegistro;
  final VoidCallback alPresionarContacto;
  final VoidCallback alPresionarInfo;

  const EnlacesInferiores({
    super.key,
    required this.alPresionarRegistro,
    required this.alPresionarContacto,
    required this.alPresionarInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          // Botón de registro destacado
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: alPresionarRegistro,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rocket_launch_outlined, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "Comenzar Ahora",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          
          // Enlaces de apoyo
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(20, 255, 255, 255),

              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _EnlaceModerno(
                  icono: Icons.support_agent_outlined,
                  texto: "Soporte",
                  onPressed: alPresionarContacto,
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: const Color.fromARGB(51, 255, 255, 255),

                ),
                _EnlaceModerno(
                  icono: Icons.info_outline_rounded,
                  texto: "Información",
                  onPressed: alPresionarInfo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EnlaceModerno extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onPressed;

  const _EnlaceModerno({
    required this.icono,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 20),
          const SizedBox(height: 4),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}