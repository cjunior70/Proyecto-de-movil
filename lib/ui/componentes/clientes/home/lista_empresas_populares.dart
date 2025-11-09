import 'package:flutter/material.dart';
import 'tarjeta_empresa.dart';

/// ✅ Lista de empresas con diseño oscuro premium y estados de carga
class ListaEmpresasPopulares extends StatelessWidget {
  final List<dynamic> empresas;
  final VoidCallback? onVerTodas;
  final ValueChanged<dynamic>? onEmpresaSeleccionada;
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
        // ✅ Header mejorado
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Empresas Populares",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: onVerTodas,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromARGB(255, 240, 208, 48)
                          .withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Ver todas",
                        style: TextStyle(
                          color: Color.fromARGB(255, 240, 208, 48),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color.fromARGB(255, 240, 208, 48),
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ✅ Lista de empresas o estado vacío
        empresas.isEmpty
            ? _buildListaVacia()
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: empresas.length,
                itemBuilder: (context, index) {
                  final empresa = empresas[index];

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
    if (empresa is Map) {
      return (empresa['rating'] ?? empresa['estrellas'] ?? 0.0).toDouble();
    }
    return empresa.rating ?? empresa.estrellas ?? 0.0;
  }

  // ✅ Skeleton loader mejorado
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ✅ Skeletons animados
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: const _SkeletonShimmer(),
            );
          },
        ),
      ],
    );
  }

  // ✅ Estado vacío mejorado
  Widget _buildListaVacia() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.business_rounded,
              color: Colors.white38,
              size: 50,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No hay empresas disponibles",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Intenta buscar o ajustar los filtros",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Efecto de shimmer para el skeleton
class _SkeletonShimmer extends StatefulWidget {
  const _SkeletonShimmer();

  @override
  State<_SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<_SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _controller.value * 2, 0),
              end: Alignment(1.0 + _controller.value * 2, 0),
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
        );
      },
    );
  }
}