import 'package:flutter/material.dart';
import 'package:proyecto/Models/Empresa.dart';
import 'package:proyecto/Models/Servicio.dart';
import 'package:proyecto/controllers/EmpresaController.dart';
import 'package:proyecto/ui/Administrador/gestionEmpleados.dart';
import '../componentes/servicio_card.dart';
import '../componentes/servicio_form.dart';

class MostrarEmpresa extends StatefulWidget {
  final Empresa empresa;

  const MostrarEmpresa({super.key, required this.empresa});

  @override
  State<MostrarEmpresa> createState() => _MostrarEmpresaState();
}

class _MostrarEmpresaState extends State<MostrarEmpresa> {
  final EmpresaController _empresaController = EmpresaController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  int _selectedIndex = 0;
  Servicio? _servicioEditando;

  void _mostrarFormularioServicio({Servicio? servicio}) {
    _servicioEditando = servicio;

    if (servicio != null) {
      _nombreController.text = servicio.Nombre ?? "";
      _precioController.text = servicio.Precio.toString();
      _duracionController.text = servicio.TiempoPromedio.inMinutes.toString();
      _descripcionController.text = servicio.Descripcion ?? '';
    } else {
      _limpiarFormulario();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(servicio == null ? 'Agregar Servicio' : 'Editar Servicio'),
        content: ServicioForm(
          nombreInicial: _nombreController.text,
          precioInicial: _precioController.text,
          duracionInicial: _duracionController.text,
          descripcionInicial: _descripcionController.text,
          esEdicion: servicio != null,
          onSubmit: _onSubmitServicio,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _procesarFormulario,
            child: Text(servicio == null ? 'Guardar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  void _procesarFormulario() {
  final nombre = _nombreController.text.trim();
  final precio = _precioController.text.trim();
  final descripcion = _descripcionController.text.trim();

    if (nombre.isEmpty || precio.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Todos los campos obligatorios'),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    _guardarServicio();
  }

  void _guardarServicio() {
    final nuevoServicio = Servicio(
      Id: _servicioEditando?.Id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      Nombre: _nombreController.text,
      Precio: double.parse(_precioController.text),
      TiempoPromedio: Duration(minutes: int.parse(_duracionController.text)),
      Descripcion:
          _descripcionController.text.isEmpty ? null : _descripcionController.text,
    );

    setState(() {
      if (_servicioEditando == null) {
        widget.empresa.ListaDeServicios ??= [];
        widget.empresa.ListaDeServicios!.add(nuevoServicio);
      } else {
        int index = widget.empresa.ListaDeServicios!
            .indexWhere((s) => s.Id == _servicioEditando!.Id);
        if (index != -1) {
          widget.empresa.ListaDeServicios![index] = nuevoServicio;
        }
      }
    });

    _limpiarFormulario();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_servicioEditando == null
            ? 'Servicio agregado exitosamente'
            : 'Servicio actualizado exitosamente'),
        backgroundColor: Colors.green.shade400,
      ),
    );
  }

  void _eliminarServicio(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Servicio'),
        content: const Text('¿Estás seguro de eliminar este servicio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.empresa.ListaDeServicios!
                    .removeWhere((s) => s.Id == id);
              });
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Servicio eliminado exitosamente'),
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

  void _limpiarFormulario() {
    _nombreController.clear();
    _precioController.clear();
    _duracionController.clear();
    _descripcionController.clear();
    _servicioEditando = null;
  }

  void _onSubmitServicio(
      String nombre, String precio, String duracion, String? descripcion) {
    _nombreController.text = nombre;
    _precioController.text = precio;
    _duracionController.text = duracion;
    _descripcionController.text = descripcion ?? '';
    _procesarFormulario();
  }

  Widget _buildInfoEmpresa() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.empresa.Nombre ?? 'Empresa',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dirección: ${widget.empresa.DescripcionUbicacion ?? 'No definida'}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(widget.empresa.DescripcionUbicacion ?? ''),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildSectionButton('Servicios', Icons.spa),
                const SizedBox(width: 12),
                _buildSectionButton('Mapa', Icons.map),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionButton(String text, IconData icon) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 16),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
      ),
    );
  }

  Widget _buildListaServicios() {
    final listaServicios = widget.empresa.ListaDeServicios ?? [];

    if (listaServicios.isEmpty) {
      return const Column(
        children: [
          Text(
            'Lista de servicios',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'No hay servicios registrados',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lista de servicios',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...listaServicios.map((servicio) => ServicioCard(
              servicio: servicio,
              onEditar: () => _mostrarFormularioServicio(servicio: servicio),
              onEliminar: () => _eliminarServicio(servicio.Id!),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.empresa.Nombre ?? 'Empresa'),
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoEmpresa(),
            const SizedBox(height: 24),
            _buildListaServicios(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _mostrarFormularioServicio(),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) =>
              //         gestionEmpleados(empresa: widget.empresa),
              //   ),
              // );
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
        },
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
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _duracionController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
}
