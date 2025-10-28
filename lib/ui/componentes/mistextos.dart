
import 'package:flutter/material.dart';

class MiTexto extends StatelessWidget {
  final String titulo;
  final bool passw;
  final TextEditingController controlador;
  final TextInputType? keyboardType;
  final String? hintText;
  final int? maxLines;

  const MiTexto({
    super.key,
    required this.titulo,
    required this.passw, 
    required this.controlador,
    this.keyboardType,
    this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        obscureText: passw,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: titulo,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 240, 208, 48),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}