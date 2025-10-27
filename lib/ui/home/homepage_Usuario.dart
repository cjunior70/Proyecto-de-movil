import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:proyecto/controllers/empresa_controller.dart';
import 'package:proyecto/ui/Cliente/EmpresaUsuario.dart';


class UsuarioHome extends StatelessWidget {
  const UsuarioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Ey!! , Vamos apartar una cita hoy ¿?",
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
              // 🔍 Buscador
              TextField(
                decoration: InputDecoration(
                  hintText: "Empresa interesada",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 📌 Categorías (tu código original)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Categories",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("See all →",
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
              const SizedBox(height: 20),

              // ⭐ Empresas Populares - SOLUCIÓN 1 CORREGIDA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Empresas Populares",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("See all →",
                      style: TextStyle(color: Colors.orange, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 10),

              // 🔥 ESTA ES LA PARTE CORREGIDA:
              _buildEmpresasList(context), // Pasar context aquí
            ],
          ),
        ),
      ),

      // 🔽 Bottom Nav (tu código original)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  // 🔥 MÉTODO CORREGIDO: Ahora es un método de la clase y recibe context
  Widget _buildEmpresasList(BuildContext context) {
    // Crear instancia del controller
    final empresaController = EmpresaController();
    empresaController.cargarEmpresaEjemplo();
    
    // Obtener las empresas del controller
    final empresas = empresaController.empresaActual != null 
        ? [empresaController.empresaActual!] 
        : [];

    // Si no hay empresas, mostrar mensaje
    if (empresas.isEmpty) {
      return const Column(
        children: [
          Text(
            "No hay empresas disponibles",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
        ],
      );
    }

    // Si hay empresas, mostrar la lista
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: empresas.length,
      itemBuilder: (context, index) {
        final empresa = empresas[index];
        return _buildCompanyCard(
          empresa.nombre,
          empresa.descripcion,
          "https://via.placeholder.com/150",
          empresa.ratingPromedio,
          onTap: () {
            // Navegar a la página de detalles
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmpresaDetallePage(empresa: empresa),
              ),
            );
          },
        );
      },
    );
  }
  // 🟠 Widget categoría
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

  // 🟠 Widget card empresa
 // Asegúrate de que tu método acepte el onTap
 Widget _buildCompanyCard(
      String name, String desc, String imageUrl, double rating,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // ← Esto permite el tap
      child: Container(
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
            // Imagen empresa
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: const Icon(Icons.business, size: 50, color: Colors.grey),
                  );
                },
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
                      Text(rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
