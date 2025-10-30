import 'package:flutter/material.dart';
import 'tarjeta_empresa.dart';

class ListaEmpresasPopulares extends StatelessWidget {
  final List<dynamic> empresas; // ✅ dynamic para cualquier modelo del backend
  final VoidCallback? onVerTodas;
  final ValueChanged<dynamic>? onEmpresaSeleccionada; // ✅ dynamic para cualquier modelo
  final bool cargando;

  const ListaEmpresasPopulares({
    super.key,
    required this.empresas,
    this.onVerTodas,
    this.onEmpresaSeleccionada,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return _buildCargando();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Empresas Populares",
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
        empresas.isEmpty
            ? _buildListaVacia()
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: empresas.length,
                itemBuilder: (context, index) {
                  final empresa = empresas[index];
                  
                  // ✅ INTERFAZ PREPARADA PARA BACKEND
                  // Tu compañero solo necesita mapear estos campos:
                return TarjetaEmpresa(
                  nombre: empresa is Map
                      ? (empresa['nombre'] ?? 'Sin nombre')
                      : (empresa.nombre ?? 'Sin nombre'),
                  descripcion: empresa is Map
                      ? (empresa['descripcion'] ?? 'Sin descripción')
                      : (empresa.descripcion ?? 'Sin descripción'),
                  imagenUrl: empresa is Map
                      ? (empresa['imagenUrl'] ?? '')
                      : (empresa.imagenUrl ?? ''),
                  rating: _obtenerRating(empresa),
                  onTap: () => onEmpresaSeleccionada?.call(empresa),
                );

                },
              ),
      ],
    );
  }

  double _obtenerRating(dynamic empresa) {
    // ✅ Flexible para diferentes estructuras de modelo
    if (empresa is Map) {
      return (empresa['rating'] ?? empresa['estrellas'] ?? 0.0).toDouble();
    }
    return empresa.rating ?? empresa.estrellas ?? 0.0;
  }

  Widget _buildCargando() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Empresas Populares",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                width: 80,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Skeletons de carga
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListaVacia() {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, color: Colors.grey, size: 40),
          SizedBox(height: 8),
          Text(
            "No hay empresas disponibles",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}