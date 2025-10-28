import 'package:flutter/material.dart';
import '../../Controllers/empleado_controller.dart';
import '../componentes/empleado_card.dart';

class GestionEmpleados extends StatefulWidget {
  const GestionEmpleados({super.key});

  @override
  State<GestionEmpleados> createState() => _GestionEmpleadosState();
}

class _GestionEmpleadosState extends State<GestionEmpleados> {
  final EmpleadoController _empleadoController = EmpleadoController();
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  void _cargarDatosIniciales() {
    _empleadoController.cargarEmpleadosEjemplo();
  }

  void _cambiarEstadoEmpleado(int index) {
    final empleado = _empleadoController.empleados[index];
    _empleadoController.cambiarEstadoEmpleado(empleado.id);
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _empleadoController.empleados[index].estado 
            ? '${empleado.nombre} activado' 
            : '${empleado.nombre} desactivado'
        ),
        backgroundColor: _empleadoController.empleados[index].estado ? Colors.green : Colors.orange,
      ),
    );
  }

  void _agregarEmpleado() {
    _mostrarEnDesarrollo(context, 'Agregar Empleado');
  }

  void _editarEmpleado(int index) {
    _mostrarEnDesarrollo(context, 'Editar Empleado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Empleados'),
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: _agregarEmpleado,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 240, 208, 48),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Agregar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 250, 250, 250),
            Color.fromARGB(255, 230, 230, 230),
          ],
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          //_buildListaEmpleados(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 208, 48),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            'Mira tus empleados',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Gestiona el estado y información de tu equipo',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget _buildListaEmpleados() {
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: ListView.builder(
  //         itemCount: _empleadoController.empleados.length,
  //         itemBuilder: (context, index) {
  //           final empleado = _empleadoController.empleados[index];
  //           return EmpleadoCard(
  //             empleado: empleado,
  //             onEditar: () => _editarEmpleado(index),
  //             onCambiarEstado: () => _cambiarEstadoEmpleado(index),
  //             index: index,
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => _navegarAPantalla(index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Citas'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Empleados'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }

  void _navegarAPantalla(int index) {
    setState(() => _selectedIndex = index);
    // Aquí iría la navegación real a otras pantallas
    if (index != 2) {
      _mostrarEnDesarrollo(context, 'Navegación a otra pantalla');
    }
  }

  void _mostrarEnDesarrollo(BuildContext context, String pantalla) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pantalla),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Funcionalidad en desarrollo...'),
            SizedBox(height: 10),
            Text('Próximamente disponible.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
