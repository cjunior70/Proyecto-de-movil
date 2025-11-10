import 'package:flutter/material.dart';

class TarjetaLogin extends StatelessWidget {
  final Widget hijo;

  const TarjetaLogin({super.key, required this.hijo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: hijo,
    );
  }
}