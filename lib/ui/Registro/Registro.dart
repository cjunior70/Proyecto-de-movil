import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto/Models/Cliente.dart';
import 'package:proyecto/Controllers/ClienteController.dart';
import 'package:proyecto/controllers/UsuarioController.dart';
import 'package:proyecto/models/Usuario.dart';
import 'dart:io';
import 'package:proyecto/ui/login/loginpage.dart';
import 'package:uuid/uuid.dart';

class Registro extends StatefulWidget {
  final String rol;

  const Registro({super.key, required this.rol});

  @override
  State<Registro> createState() => _RegistroState();

}


class _RegistroState extends State<Registro> {
  
    @override
    void initState() {
      super.initState();
    }

  final _formKey = GlobalKey<FormState>();
  bool _cargando = false;

  final TextEditingController cedulaCtrl = TextEditingController();
  final TextEditingController primerNombreCtrl = TextEditingController();
  final TextEditingController segundoNombreCtrl = TextEditingController();
  final TextEditingController primerApellidoCtrl = TextEditingController();
  final TextEditingController segundoApellidoCtrl = TextEditingController();
  final TextEditingController correoCtrl = TextEditingController();
  final TextEditingController telefonoCtrl = TextEditingController();

  String? sexoSeleccionado;
  File? foto;

  Future<void> _seleccionarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        foto = File(imagen.path);
      });
    }
  }

  void _guardarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _cargando = true);

      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));

      if (widget.rol == "Administrador") {
        Usuario nuevoUsuario = Usuario(
          Cedula: cedulaCtrl.text,
          PrimerNombre: primerNombreCtrl.text,
          SegundoNombre: segundoNombreCtrl.text,
          PrimerApellido: primerApellidoCtrl.text,
          SegundoApellido: segundoApellidoCtrl.text,
          Telefono: telefonoCtrl.text,
          Correo: correoCtrl.text,
          Sexo: sexoSeleccionado,
          Rol: widget.rol,
        );

        UsuarioController().guardarUsuario(nuevoUsuario);

        _mostrarExito('Usuario registrado exitosamente');
      } else {
        Cliente nuevoCliente = Cliente(
          Cedula: cedulaCtrl.text,
          PrimerNombre: primerNombreCtrl.text,
          SegundoNombre: segundoNombreCtrl.text,
          PrimerApellido: primerApellidoCtrl.text,
          SegundoApellido: segundoApellidoCtrl.text,
          Telefono: telefonoCtrl.text,
          Correo: correoCtrl.text,
          Sexo: sexoSeleccionado,
          Rol: widget.rol,
        );

        ClienteController().guardarCliente(nuevoCliente);

        _mostrarExito('Cliente registrado exitosamente');
      }

      setState(() => _cargando = false);

      // Navegar al login después de 1 segundo
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(mensaje),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFotoSection(),
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
                        _buildTextField(
                          'Cédula',
                          cedulaCtrl,
                          Icons.badge,
                          TextInputType.number,
                          required: true,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                'Primer Nombre',
                                primerNombreCtrl,
                                Icons.person,
                                TextInputType.text,
                                required: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                'Segundo Nombre',
                                segundoNombreCtrl,
                                Icons.person_outline,
                                TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                'Primer Apellido',
                                primerApellidoCtrl,
                                Icons.person,
                                TextInputType.text,
                                required: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                'Segundo Apellido',
                                segundoApellidoCtrl,
                                Icons.person_outline,
                                TextInputType.text,
                              ),
                            ),
                          ],
                        ),
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
                        _buildTextField(
                          'Teléfono',
                          telefonoCtrl,
                          Icons.phone,
                          TextInputType.phone,
                          required: true,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          'Correo Electrónico',
                          correoCtrl,
                          Icons.email,
                          TextInputType.emailAddress,
                          required: true,
                        ),
                        const SizedBox(height: 12),
                        _buildSexoDropdown(),
                        const SizedBox(height: 32),
                        _buildBotonGuardar(),
                        const SizedBox(height: 16),
                      ],
                    ),
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
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Crear cuenta de ${widget.rol}',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFotoSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _seleccionarFoto,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: foto == null
                    ? const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 240, 208, 48),
                          Color.fromARGB(255, 255, 220, 100),
                        ],
                      )
                    : null,
                border: Border.all(
                  color: const Color.fromARGB(255, 240, 208, 48),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: foto != null
                  ? ClipOval(child: Image.file(foto!, fit: BoxFit.cover))
                  : const Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Colors.white,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _seleccionarFoto,
            icon: const Icon(
              Icons.camera_alt,
              color: Color.fromARGB(255, 240, 208, 48),
            ),
            label: Text(
              foto == null ? 'Agregar foto' : 'Cambiar foto',
              style: const TextStyle(
                color: Color.fromARGB(255, 240, 208, 48),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    TextInputType tipo, {
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipo,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 240, 208, 48)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 240, 208, 48),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: required
          ? (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null
          : null,
    );
  }

  Widget _buildSexoDropdown() {
    return DropdownButtonFormField<String>(
      value: sexoSeleccionado,
      dropdownColor: const Color.fromARGB(255, 45, 45, 45),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Sexo *',
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: const Icon(
          Icons.wc,
          color: Color.fromARGB(255, 240, 208, 48),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 240, 208, 48),
            width: 2,
          ),
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: 'Masculino',
          child: Text('Masculino'),
        ),
        DropdownMenuItem(
          value: 'Femenino',
          child: Text('Femenino'),
        ),
        DropdownMenuItem(
          value: 'Otro',
          child: Text('Otro'),
        ),
      ],
      onChanged: (valor) => setState(() => sexoSeleccionado = valor),
      validator: (value) => value == null ? 'Seleccione un sexo' : null,
    );
  }

  Widget _buildBotonGuardar() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _cargando ? null : _guardarFormulario,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 240, 208, 48),
          disabledBackgroundColor: Colors.white24,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.5),
        ),
        child: _cargando
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Text(
                'Guardar y Continuar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}