import 'package:flutter/material.dart';
import 'package:proyecto/models/empresa_model.dart';
import 'package:proyecto/ui/Administrador/gestionEmpleados.dart';
import '../../controllers/empresa_controller.dart';
import '../../Controllers/servicio_controller.dart';
import '../../Models/servicio_model.dart';
import '../componentes/servicio_card.dart';
import '../componentes/servicio_form.dart';

class MostrarEmpresa extends StatefulWidget { 
  final Empresa empresa;
  
  const MostrarEmpresa({super.key, required this.empresa});  

  @override
  State<MostrarEmpresa> createState() => _MostrarEmpresaState();  
}

class _MostrarEmpresaState extends State<MostrarEmpresa> { 
  final ServicioController _servicioController = ServicioController();
  final EmpresaController _empresaController = EmpresaController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  int _selectedIndex = 0;
  Servicio? _servicioEditando;

@override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  void _cargarDatosIniciales() {
    _servicioController.cargarServiciosEjemplo();
  }
  void _mostrarFormularioServicio({Servicio? servicio}) {
    _servicioEditando = servicio;
    
    if (servicio != null) {
      _nombreController.text = servicio.nombre;
      _precioController.text = servicio.precio.toString();
      _duracionController.text = servicio.duracion.replaceAll(' minutos', '');
      _descripcionController.text = servicio.descripcion ?? '';
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
    final error = _servicioController.validarServicio(
      _nombreController.text,
      _precioController.text,
      _duracionController.text,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    _guardarServicio();
  }

  void _guardarServicio() {
    final nuevoServicio = Servicio(
      id: _servicioEditando?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: _nombreController.text,
      precio: double.parse(_precioController.text),
      duracion: '${_duracionController.text} minutos',
      descripcion: _descripcionController.text.isEmpty ? null : _descripcionController.text,
    );

    if (_servicioEditando == null) {
      _servicioController.agregarServicio(nuevoServicio);
    } else {
      _servicioController.editarServicio(_servicioEditando!.id, nuevoServicio);
    }

    setState(() {});
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
              _servicioController.eliminarServicio(id);
              setState(() {});
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

  void _onSubmitServicio(String nombre, String precio, String duracion, String? descripcion) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.empresa.nombre, // ← Usar widget.empresa
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        '${widget.empresa.totalReviews} Reviews',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Dirección: ${widget.empresa.direccion}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descripción',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(widget.empresa.descripcion),
            const SizedBox(height: 8),
            const Text('Redes Sociales'),
            const SizedBox(height: 8),
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

  Widget _buildListaServicios() {
    if (_servicioController.servicios.isEmpty) {
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
        
        // Encabezados
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Row(
            children: [
              Expanded(flex: 2, child: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Precio', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('Tiempo', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Lista de servicios
        ..._servicioController.servicios.map((servicio) => ServicioCard(
          servicio: servicio,
          onEditar: () => _mostrarFormularioServicio(servicio: servicio),
          onEliminar: () => _eliminarServicio(servicio.id),
        )).toList(),
      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresa Josemaria'),
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
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
            
            // Botones de acción
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
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Datos guardados exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Estado
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Estado: Todos los cambios guardados'),
                ],
              ),
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
              // Inicio - ya está en esta página
              break;
            case 1:
              // Citas - mostrar mensaje temporal
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gestión de Citas - Próximamente'),
                  backgroundColor: Colors.blue,
                ),
              );
              break;
            case 2:
              // SOLO ESTE BOTÓN abre GestionEmpleados
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GestionEmpleados()),
              );
              break;
            case 3:
              // Perfil - mostrar mensaje temporal
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