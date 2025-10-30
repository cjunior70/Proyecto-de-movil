import 'package:flutter/material.dart';
import 'package:proyecto/ui/Administrador/gestionEmpleados.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      backgroundColor: const Color.fromARGB(255, 240, 208, 48),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black54,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      showUnselectedLabels: true,
      onTap: (index) => _handleTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Citas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Empleados',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }

  void _handleTap(BuildContext context, int index) {
    onTap(index);

    switch (index) {
      case 0:
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gestión de Citas - Próximamente'),
            backgroundColor: Colors.blue,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GestionEmpleados()),
        );
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil de Usuario - Próximamente'),
            backgroundColor: Colors.purple,
          ),
        );
        break;
    }
  }
}