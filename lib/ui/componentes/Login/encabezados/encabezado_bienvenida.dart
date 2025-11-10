import 'package:flutter/material.dart';

class EncabezadoBienvenida extends StatelessWidget {
  const EncabezadoBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 240, 208, 48),
            shape: BoxShape.circle,
          ),
          child: Image.network(
            "https://cdn-icons-png.flaticon.com/512/6703/6703553.png",
            width: 60,
            height: 60,
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          "¡Bienvenido!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B4E71),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "¿Cómo está tu corte hoy?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}