import 'package:flutter/material.dart';
import 'package:proyecto/Models/Empresa.dart';

class Cartaempresa extends StatelessWidget {
  final Empresa empresa;
  final VoidCallback? onTap; // 👈 para manejar toques opcionales

  const Cartaempresa({
    super.key,
    required this.empresa,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: empresa.ImagenMiniatura != null
              ? Image.memory(
                  empresa.ImagenMiniatura!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  "https://via.placeholder.com/150",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          empresa.Nombre ?? "Empresa sin nombre",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          empresa.Correo ?? "Sin correo registrado",
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: onTap,
      ),
    );
  }
}
