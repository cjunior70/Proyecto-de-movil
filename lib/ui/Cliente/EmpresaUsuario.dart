import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/empresa_model.dart';
import '../../models/empleado_model.dart';
import '../../Controllers/empleado_controller.dart';

class EmpresaDetallePage extends StatelessWidget {
  final Empresa empresa;

  const EmpresaDetallePage({super.key, required this.empresa});

  @override
  Widget build(BuildContext context) {
    final empleadoController = EmpleadoController();
    empleadoController.cargarEmpleadosEjemplo();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Detalles de Empresa'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con imagen
            _buildHeader(context),
            
            // Información principal
            _buildInfoEmpresa(),
            
            // Sección de acciones
            _buildActionSection(),
            
            // Descripción
            _buildDescripcion(),
            
            // Horario laboral
            _buildHorarioLaboral(),
            
            // Empleados
            _buildEmpleadosSection(empleadoController),
          ],
        ),
      ),
      
      // Botón flotante para reservar
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a creación de reserva
          _navegarAReserva(context, empresa, empleadoController.empleados);
        },
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.calendar_today),
        label: const Text('Reservar Cita'),
      ),
    );
  }

  // 🏢 Header con imagen de la empresa
  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://via.placeholder.com/400x200"), // Imagen temporal
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // 📍 Información principal de la empresa
  Widget _buildInfoEmpresa() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            empresa.nombre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            empresa.direccion,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          
          // Rating y reviews
          Row(
            children: [
              RatingBarIndicator(
                rating: empresa.ratingPromedio,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20,
                direction: Axis.horizontal,
              ),
              const SizedBox(width: 8),
              Text(
                empresa.ratingPromedio.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${empresa.totalReviews} Reviews)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔘 Sección de acciones (Redes Sociales, Servicios, Mapa)
  Widget _buildActionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton('Redes Sociales', Icons.share),
          _buildActionButton('Servicios', Icons.room_service),
          _buildActionButton('Mapa', Icons.map),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.orange),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // 📝 Descripción de la empresa
  Widget _buildDescripcion() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            empresa.descripcion,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ⏰ Horario laboral
  Widget _buildHorarioLaboral() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horario Laboral',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildHorarioItem('Comienzo Laboral:', '7:00 AM'),
          _buildHorarioItem('Finalización Laboral:', '8:00 PM'),
          _buildHorarioItem('Correo Electrónico:', empresa.email),
        ],
      ),
    );
  }

  Widget _buildHorarioItem(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            valor,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 👥 Sección de empleados
  Widget _buildEmpleadosSection(EmpleadoController controller) {
    final empleadosActivos = controller.empleados.where((e) => e.estado).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mira sus empleados, a quien quieres ¿?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: empleadosActivos.length,
            itemBuilder: (context, index) {
              return _buildEmpleadoCard(empleadosActivos[index]);
            },
          ),
        ],
      ),
    );
  }

  // 🪪 Tarjeta de empleado
  Widget _buildEmpleadoCard(Empleado empleado) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar del empleado
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.orange.shade600,
            ),
          ),
          const SizedBox(width: 12),
          
          // Información del empleado
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  empleado.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  empleado.cargo,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: empleado.estado ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        empleado.estado ? 'Activado' : 'Desactivado',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Botón para seleccionar
          IconButton(
            onPressed: () {
              // Seleccionar empleado para reserva
            },
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }

  // 🎯 Navegación a reserva
  void _navegarAReserva(BuildContext context, Empresa empresa, List<Empleado> empleados) {
    // Aquí navegarás a la pantalla de creación de reserva
    // Por ahora solo un placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando a reserva con ${empresa.nombre}'),
        backgroundColor: Colors.orange,
      ),
    );
    
    // Descomenta cuando tengas la pantalla de reserva:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CrearReservaPage(
    //       empresa: empresa,
    //       empleados: empleados,
    //     ),
    //   ),
    // );
  }
}