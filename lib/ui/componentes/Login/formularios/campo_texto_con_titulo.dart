import 'package:flutter/material.dart';

class CampoTextoConTitulo extends StatelessWidget {
  final String titulo;
  final bool esPassword;
  final TextEditingController controlador;
  
  const CampoTextoConTitulo({
    super.key,
    required this.titulo,
    required this.esPassword,
    required this.controlador,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controlador,
            obscureText: esPassword,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              
            ),
          ),
        ),
      ],
    );
  }
}