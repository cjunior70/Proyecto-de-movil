import 'package:flutter/material.dart';
import '../../comunes/tarjetas/tarjeta_categoria.dart';

class CategoriasHome extends StatelessWidget {
  final VoidCallback? onVerTodas;
  final ValueChanged<String>? onCategoriaSeleccionada;
  final String? categoriaSeleccionada;
  final List<Map<String, dynamic>> categorias;

  const CategoriasHome({
    super.key,
    this.onVerTodas,
    this.onCategoriaSeleccionada,
    this.categoriaSeleccionada,
    this.categorias = const [
      {
        'id': 'corte',
        'nombre': 'Corte',
        'icono': Icons.content_cut,
        'color': Colors.orange,
      },
      {
        'id': 'coloracion',
        'nombre': 'Coloración',
        'icono': Icons.brush,
        'color': Colors.purple,
      },
      {
        'id': 'facial',
        'nombre': 'Facial',
        'icono': Icons.spa,
        'color': Colors.green,
      },
      {
        'id': 'manicure', 
        'nombre': 'Manicure',
        'icono': Icons.self_improvement,
        'color': Colors.pink,
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categorías",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: onVerTodas,
                child: const Text(
                  "Ver todas",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110, // Altura fija para evitar overflow
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            children: categorias.map((categoria) {
              return TarjetaCategoria(
                titulo: categoria['nombre'],
                icono: categoria['icono'],
                colorIcono: categoria['color'],
                seleccionada: categoriaSeleccionada == categoria['id'],
                onTap: () => onCategoriaSeleccionada?.call(categoria['id']),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}