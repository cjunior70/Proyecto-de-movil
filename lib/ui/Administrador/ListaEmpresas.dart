import 'package:flutter/material.dart';
import 'package:proyecto/Models/Empresa.dart';
import 'package:proyecto/controllers/EmpresaController.dart';
import 'package:proyecto/ui/Administrador/mostrarEmpresa.dart';

class ListaEmpresas extends StatefulWidget {
  const ListaEmpresas({super.key});

  @override
  State<ListaEmpresas> createState() => _ListaEmpresasState();
}

class _ListaEmpresasState extends State<ListaEmpresas> {
  final EmpresaController _empresaController = EmpresaController();
  final List<Empresa> _empresas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarEmpresas();
  }

  Future<void> _cargarEmpresas() async {
  setState(() {
    _isLoading = true;
  });

  // Simular carga de datos
  await Future.delayed(const Duration(milliseconds: 800));

  final empresas = _empresaController.obtenerEmpresas();

  setState(() {
    _empresas.clear(); // Limpiar antes de agregar
    _empresas.addAll(empresas);
    if (_empresas.isNotEmpty) {
      print(_empresas[0].Nombre); // Ojo: el índice 1 puede fallar si hay <2
    }
    _isLoading = false;
  });
}

  void _navegarADetalleEmpresa(Empresa empresa) {
    print("Estoy llendo a algo");
    Navigator.push(
      context,
      MaterialPageRoute(
        //la parte que selecciono con comillas tiene un error ("empresa": empresa)
        builder: (context) => MostrarEmpresa(empresa: empresa),
        
      ),
    );
  }

  void _mostrarOpcionesEmpresa(Empresa empresa, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.blue),
              title: const Text('Ver Detalles'),
              onTap: () {
                Navigator.pop(context);
                _navegarADetalleEmpresa(empresa);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Editar Empresa'),
              onTap: () {
                Navigator.pop(context);
                _editarEmpresa(empresa);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar Empresa'),
              onTap: () {
                Navigator.pop(context);
                _eliminarEmpresa(empresa);
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editarEmpresa(Empresa empresa) {
    // TODO: Implementar edición de empresa
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar empresa: ${empresa.Nombre}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _eliminarEmpresa(Empresa empresa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Empresa'),
        content: Text('¿Estás seguro de eliminar "${empresa.Nombre}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _empresas.removeWhere((e) => e.Id == empresa.Id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Empresa "${empresa.Nombre}" eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpresaCard(Empresa empresa) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 240, 208, 48),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.business, color: Colors.white),
        ),
        title: Text(
          empresa.Nombre ?? "",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              empresa.DescripcionUbicacion ?? "",
              style: const TextStyle(color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Row(
            //   children: [
            //     const Icon(Icons.star, color: Colors.amber, size: 16),
            //     const SizedBox(width: 4),
            //     Text(
            //       empresa.ratingPromedio.toStringAsFixed(1),
            //       style: const TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     const SizedBox(width: 8),
            //     const Icon(Icons.reviews, color: Colors.grey, size: 16),
            //     const SizedBox(width: 4),
            //     Text('${empresa.totalReviews} reviews'),
            //   ],
            // ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'ver':
                _navegarADetalleEmpresa(empresa);
                break;
              case 'editar':
                _editarEmpresa(empresa);
                break;
              case 'eliminar':
                _eliminarEmpresa(empresa);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'ver',
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text('Ver Detalles'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'eliminar',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Eliminar'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _navegarADetalleEmpresa(empresa),
        onLongPress: () => _mostrarOpcionesEmpresa(empresa, context),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) => Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          title: Container(
            height: 16,
            width: 150,
            color: Colors.grey.shade300,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 200,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 6),
              Container(
                height: 12,
                width: 120,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.business_center,
          size: 80,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 16),
        const Text(
          'No hay empresas registradas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Presiona el botón "+" para agregar tu primera empresa',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            // Navegar a registrar empresa
            Navigator.pop(context);
          },
          icon: const Icon(Icons.add_business),
          label: const Text('Registrar Primera Empresa'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Empresas'),
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Búsqueda de empresas - Próximamente'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementar filtros
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtros de empresas - Próximamente'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header informativo
              Card(
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.white70),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_empresas.length} empresas registradas',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lista de empresas
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _empresas.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async {
                              _cargarEmpresas();
                            },
                            child: ListView.builder(
                              itemCount: _empresas.length,
                              itemBuilder: (context, index) =>
                                  _buildEmpresaCard(_empresas[index]),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a registrar nueva empresa
          Navigator.pop(context);
        },
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_business),
      ),
    );
  }
}