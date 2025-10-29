import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:proyecto/Controllers/EmpresaController.dart';
import 'package:proyecto/Models/Empresa.dart';
import 'package:proyecto/ui/Cliente/ClienteDetallePage.dart';

class UsuarioHome extends StatefulWidget {
  const UsuarioHome({super.key});

  @override
  State<UsuarioHome> createState() => _UsuarioHomeState();
}

class _UsuarioHomeState extends State<UsuarioHome> {
  final EmpresaController _empresaController = EmpresaController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _cargarEmpresasEjemplo();
  }

  void _cargarEmpresasEjemplo() {
    if (_empresaController.obtenerEmpresas().isEmpty) {
      _empresaController.guardarEmpresa(Empresa(
        Id: "e1",
        Nombre: "Barbería Elite",
        Estrellas: 4.8,
        Correo: "elite@barber.com",
        usuario: null,
      ));
      _empresaController.guardarEmpresa(Empresa(
        Id: "e2",
        Nombre: "Spa Relax",
        Estrellas: 4.5,
        Correo: "relax@spa.com",
        usuario: null,
      ));
      _empresaController.guardarEmpresa(Empresa(
        Id: "e3",
        Nombre: "Café Style",
        Estrellas: 4.2,
        Correo: "cafe@style.com",
        usuario: null,
      ));
    }
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 3) {
      // Navegar a ClienteDetallePage directamente
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClienteDetallePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final empresas = _empresaController.obtenerEmpresas();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Ey!! , Vamos a apartar una cita hoy ¿?",
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.orange),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildCategories(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Empresas Populares",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Ver todas →",
                      style: TextStyle(color: Colors.orange, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: empresas.length,
                itemBuilder: (context, index) {
                  final empresa = empresas[index];
                  return _buildCompanyCard(
                    empresa.Nombre,
                    empresa.Correo,
                    empresa.ImagenGeneral != null
                        ? Image.memory(empresa.ImagenGeneral!).toString()
                        : "https://via.placeholder.com/150",
                    empresa.Estrellas,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Buscar empresa...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Categorías",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Ver todas →",
                style: TextStyle(color: Colors.orange, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategory("Corte de caballero", Icons.cut),
              _buildCategory("Coloración", Icons.brush),
              _buildCategory("Facial", Icons.spa),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildCategory(String title, IconData icon) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange, size: 30),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  static Widget _buildCompanyCard(
      String name, String desc, String imageUrl, double rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.orange)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 18,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 6),
                    Text(rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: _onNavTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}
