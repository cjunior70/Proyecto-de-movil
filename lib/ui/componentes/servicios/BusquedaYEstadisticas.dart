import 'package:flutter/material.dart';

class BusquedaYEstadisticas extends StatelessWidget {
  final TextEditingController searchController;
  final int serviciosFiltradosCount;
  final VoidCallback onClearSearch;

  const BusquedaYEstadisticas({
    super.key,
    required this.searchController,
    required this.serviciosFiltradosCount,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // BARRA DE BÚSQUEDA
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            // El onChanged sigue llamando a _filtrarServicios en el padre (GestionServiciosState)
            // porque searchController fue pasado por referencia y tiene un listener allí.
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar servicio...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color.fromARGB(255, 240, 208, 48),
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      onPressed: onClearSearch,
                    )
                  : null,
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 240, 208, 48),
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        // TARJETA DE ESTADÍSTICAS
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.room_service_rounded,
                  color: Color.fromARGB(255, 240, 208, 48),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$serviciosFiltradosCount Servicios',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      searchController.text.isEmpty
                          ? 'Total registrados'
                          : 'Resultados de búsqueda',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}