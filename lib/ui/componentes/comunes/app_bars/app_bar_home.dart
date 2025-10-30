import 'package:flutter/material.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final VoidCallback? onNotificacionPresionada;

  const AppBarHome({
    super.key,
    required this.titulo,
    this.onNotificacionPresionada,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        titulo,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.orange),
          onPressed: onNotificacionPresionada,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}