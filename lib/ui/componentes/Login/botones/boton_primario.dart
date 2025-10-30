import 'package:flutter/material.dart';

class BotonPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback alPresionar;
  final bool estaCargando;

  const BotonPrimario({
    super.key,
    required this.texto,
    required this.alPresionar,
    this.estaCargando = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: estaCargando ? null : alPresionar,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 240, 208, 48),
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: const Color.fromARGB(255, 240, 208, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: estaCargando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                texto,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}