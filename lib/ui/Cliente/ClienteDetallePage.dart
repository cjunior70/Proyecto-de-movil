import 'package:flutter/material.dart';
import 'package:proyecto/Controllers/ClienteController.dart';
import 'package:proyecto/Models/Cliente.dart';

class ClienteDetallePage extends StatefulWidget {
  const ClienteDetallePage({super.key});

  @override
  State<ClienteDetallePage> createState() => _ClienteDetallePageState();
}

class _ClienteDetallePageState extends State<ClienteDetallePage> {
  Cliente? cliente;
  bool _modoEdicion = false;
  bool _guardando = false;

  // Controladores de los TextFields
  final TextEditingController cedulaCtrl = TextEditingController();
  final TextEditingController primerNombreCtrl = TextEditingController();
  final TextEditingController segundoNombreCtrl = TextEditingController();
  final TextEditingController primerApellidoCtrl = TextEditingController();
  final TextEditingController segundoApellidoCtrl = TextEditingController();
  final TextEditingController telefonoCtrl = TextEditingController();
  final TextEditingController correoCtrl = TextEditingController();
  String? sexoSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarDatosCliente();
  }

  void _cargarDatosCliente() {
    // ✅ Tu compañero conectará esto con el API
    cliente = ClienteController().obtenerCliente();

    if (cliente != null) {
      cedulaCtrl.text = cliente!.Cedula ?? "";
      primerNombreCtrl.text = cliente!.PrimerNombre ?? "";
      segundoNombreCtrl.text = cliente!.SegundoNombre ?? "";
      primerApellidoCtrl.text = cliente!.PrimerApellido ?? "";
      segundoApellidoCtrl.text = cliente!.SegundoApellido ?? "";
      telefonoCtrl.text = cliente!.Telefono ?? "";
      correoCtrl.text = cliente!.Correo ?? "";
      sexoSeleccionado = cliente!.Sexo;
    }
  }

  void _toggleModoEdicion() {
    setState(() {
      _modoEdicion = !_modoEdicion;
      if (!_modoEdicion) {
        // Si cancela edición, restaurar datos originales
        _cargarDatosCliente();
      }
    });
  }

  void _guardarCambios() async {
    if (cliente == null) return;

    setState(() => _guardando = true);

    // Simular guardado
    await Future.delayed(const Duration(seconds: 1));

    Cliente actualizado = Cliente(
      Id: cliente!.Id,
      Cedula: cedulaCtrl.text,
      PrimerNombre: primerNombreCtrl.text,
      SegundoNombre: segundoNombreCtrl.text,
      PrimerApellido: primerApellidoCtrl.text,
      SegundoApellido: segundoApellidoCtrl.text,
      Telefono: telefonoCtrl.text,
      Correo: correoCtrl.text,
      Sexo: sexoSeleccionado,
      Foto: cliente!.Foto,
      Rol: cliente!.Rol,
      ListaDeReservaciones: cliente!.ListaDeReservaciones,
    );

    ClienteController().actualizarCliente(actualizado);

    setState(() {
      cliente = ClienteController().obtenerCliente();
      _guardando = false;
      _modoEdicion = false;
    });

    _mostrarSnackBar('✅ Datos actualizados correctamente', Colors.green);
  }

  void _mostrarSnackBar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.info,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cliente == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 35, 35, 35),
                Color.fromARGB(255, 55, 55, 55),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_off,
                    size: 80,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No hay cliente registrado",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Inicia sesión primero",
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Volver',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 35, 35, 35),
              Color.fromARGB(255, 55, 55, 55),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPerfilCard(),
                      const SizedBox(height: 24),
                      const Text(
                        'Información Personal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('Cédula', cedulaCtrl, Icons.badge),
                      const SizedBox(height: 12),
                      _buildTextField(
                          'Primer Nombre', primerNombreCtrl, Icons.person),
                      const SizedBox(height: 12),
                      _buildTextField('Segundo Nombre', segundoNombreCtrl,
                          Icons.person_outline),
                      const SizedBox(height: 12),
                      _buildTextField(
                          'Primer Apellido', primerApellidoCtrl, Icons.person),
                      const SizedBox(height: 12),
                      _buildTextField('Segundo Apellido', segundoApellidoCtrl,
                          Icons.person_outline),
                      const SizedBox(height: 24),
                      const Text(
                        'Información de Contacto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('Teléfono', telefonoCtrl, Icons.phone),
                      const SizedBox(height: 12),
                      _buildTextField('Correo', correoCtrl, Icons.email),
                      const SizedBox(height: 12),
                      _buildSexoDropdown(),
                      const SizedBox(height: 32),
                      if (_modoEdicion) _buildBotonesEdicion(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi Perfil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Información personal',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _modoEdicion ? Icons.close : Icons.edit,
              color: _modoEdicion ? Colors.red : Colors.white,
            ),
            onPressed: _toggleModoEdicion,
            tooltip: _modoEdicion ? 'Cancelar' : 'Editar',
          ),
        ],
      ),
    );
  }

  Widget _buildPerfilCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 240, 208, 48),
                  Color.fromARGB(255, 255, 220, 100),
                ],
              ),
              border: Border.all(
                color: const Color.fromARGB(255, 240, 208, 48),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${cliente!.PrimerNombre} ${cliente!.PrimerApellido}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cliente!.Correo ?? 'Sin correo',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.5)),
                  ),
                  child: Text(
                    cliente!.Rol ?? 'Cliente',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      enabled: _modoEdicion,
      style: TextStyle(
        color: _modoEdicion ? Colors.white : Colors.white70,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: _modoEdicion ? Colors.white60 : Colors.white38,
        ),
        prefixIcon: Icon(
          icon,
          color: _modoEdicion
              ? const Color.fromARGB(255, 240, 208, 48)
              : Colors.white38,
        ),
        filled: true,
        fillColor: _modoEdicion
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _modoEdicion
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 240, 208, 48),
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
    );
  }

  Widget _buildSexoDropdown() {
    return DropdownButtonFormField<String>(
      value: sexoSeleccionado,
      dropdownColor: const Color.fromARGB(255, 45, 45, 45),
      style: TextStyle(
        color: _modoEdicion ? Colors.white : Colors.white70,
      ),
      decoration: InputDecoration(
        labelText: 'Sexo',
        labelStyle: TextStyle(
          color: _modoEdicion ? Colors.white60 : Colors.white38,
        ),
        prefixIcon: Icon(
          Icons.wc,
          color: _modoEdicion
              ? const Color.fromARGB(255, 240, 208, 48)
              : Colors.white38,
        ),
        filled: true,
        fillColor: _modoEdicion
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _modoEdicion
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
        DropdownMenuItem(value: 'Otro', child: Text('Otro')),
      ],
      onChanged:
          _modoEdicion ? (valor) => setState(() => sexoSeleccionado = valor) : null,
    );
  }

  Widget _buildBotonesEdicion() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _guardando ? null : _toggleModoEdicion,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withOpacity(0.3)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _guardando ? null : _guardarCambios,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 208, 48),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _guardando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}