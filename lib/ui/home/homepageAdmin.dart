import 'package:flutter/material.dart';
import 'package:proyecto/ui/Administrador/ListaEmpresas.dart';
import 'package:proyecto/ui/Administrador/RegistrarEmpresaPage.dart';
import 'package:proyecto/ui/Administrador/mostrarEmpresa.dart';

class HomepageAdmin extends StatelessWidget {
  const HomepageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 43, 43, 43),
              Color.fromARGB(255, 144, 144, 144),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título de bienvenida
              const Text(
                'Gestión de Empresas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona una opción para comenzar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Card para Registrar Empresa
              _buildOptionCard(
                icon: Icons.business_center,
                title: 'Registrar Empresa',
                subtitle: 'Agregar nueva empresa al sistema',
                color: const Color.fromARGB(255, 240, 208, 48),
                onTap: () {
                  _mostrarRegistrarEmpresa(context);
                },
              ),
              const SizedBox(height: 20),

              // Card para Mostrar Empresas
              _buildOptionCard(
                icon: Icons.list_alt,
                title: 'Mostrar Empresas',
                subtitle: 'Ver y gestionar empresas registradas',
                color: const Color(0xFF6B4E71),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ListaEmpresas()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _mostrarRegistrarEmpresa(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrarEmpresaPage(),
      ),
    );
  }
}