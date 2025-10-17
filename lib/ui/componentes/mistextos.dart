
import 'package:flutter/material.dart';

class MiTexto extends StatelessWidget {
  final String titulo;
  final bool passw;
  final TextEditingController controlador;
  const MiTexto({
    super.key,
    required this.titulo,
    required this.passw, 
    required this.controlador
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        obscureText: passw,
        decoration: InputDecoration(labelText: titulo),),
    );
  }
}