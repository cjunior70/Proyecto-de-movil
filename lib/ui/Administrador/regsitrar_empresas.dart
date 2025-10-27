import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto/controllers/empresa_controller.dart';
import 'package:proyecto/models/empresa_model.dart';

class RegistrarEmpresaPage extends StatefulWidget {
  const RegistrarEmpresaPage({super.key});

  @override
  State<RegistrarEmpresaPage> createState() => _RegistroEmpresaPageState();
}

class _RegistroEmpresaPageState extends State<RegistrarEmpresaPage> {
  final _formKey = GlobalKey<FormState>();
  final EmpresaController _empresaController = EmpresaController();
  
 
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  
  TimeOfDay _horaInicio = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _horaFin = const TimeOfDay(hour: 20, minute: 0);
  
 
  final ImagePicker _picker = ImagePicker();
  XFile? _imagenMiniatura;
  XFile? _imagenGlobal;

  @override
  void dispose() {
   
    _nombreController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    _descripcionController.dispose();
    _telefonoController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }


  Future<void> _seleccionarImagen(bool esMiniatura) async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        if (esMiniatura) {
          _imagenMiniatura = imagen;
        } else {
          _imagenGlobal = imagen;
        }
      });
    }
  }

 
  Future<void> _seleccionarHora(bool esInicio) async {
    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: esInicio ? _horaInicio : _horaFin,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
    
    if (horaSeleccionada != null) {
      setState(() {
        if (esInicio) {
          _horaInicio = horaSeleccionada;
        } else {
          _horaFin = horaSeleccionada;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Empresa'),
        backgroundColor: const Color.fromARGB(255, 240, 208, 48),
        foregroundColor: Colors.white,
        elevation: 0,
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildSectionTitle('Datos de tu empresa'),
                  const SizedBox(height: 16),

                 
                  _buildTextField(
                    controller: _nombreController,
                    label: 'Nombre de la empresa',
                    icon: Icons.business,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(
                    controller: _emailController,
                    label: 'Correo Electrónico',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El correo es obligatorio';
                      }
                      if (!value.contains('@')) {
                        return 'Correo electrónico inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(
                    controller: _direccionController,
                    label: 'Descripción de la ubicación',
                    icon: Icons.location_on,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La dirección es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(
                    controller: _descripcionController,
                    label: 'Descripción del negocio',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(
                    controller: _telefonoController,
                    label: 'Teléfono',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El teléfono es obligatorio';
                      }
                      
                      if (!RegExp(r'^\d{7,10}$').hasMatch(value)) {
                        return 'Número inválido (7-10 dígitos)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  
                  _buildSectionTitle('Horario Laboral'),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePicker(
                          label: 'Comienzo Laboral',
                          time: _horaInicio,
                          onTap: () => _seleccionarHora(true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimePicker(
                          label: 'Finalización Laboral', 
                          time: _horaFin,
                          onTap: () => _seleccionarHora(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Mostremos unas foto del negocio'),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildImageUploader(
                          label: 'Foto Miniatura',
                          imagen: _imagenMiniatura,
                          onTap: () => _seleccionarImagen(true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildImageUploader(
                          label: 'Foto Global',
                          imagen: _imagenGlobal,
                          onTap: () => _seleccionarImagen(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  
                  _buildSectionTitle('¿Donde queda tu negocio?'),
                  const SizedBox(height: 8),
                  const Text(
                    'Vamos a buscarlo en el mapa',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMapPlaceholder(),
                  const SizedBox(height: 20),

                 
                  _buildSectionTitle('Redes sociales'),
                  const SizedBox(height: 12),

                  _buildTextField(
                    controller: _facebookController,
                    label: 'Facebook',
                    icon: Icons.facebook,
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(
                    controller: _instagramController,
                    label: 'Instagram',
                    icon: Icons.camera_alt,
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(
                    controller: _whatsappController,
                    label: 'Whatsapp',
                    icon: Icons.chat,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),

                  // Botón de guardar 
                  _buildSaveButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //  Widget para títulos de seccion
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // Widget para campos de texto 
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromARGB(255, 240, 208, 48)),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

  // Widget para seleccionar hora
  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white54),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget para imágenes
  Widget _buildImageUploader({
    required String label,
    required XFile? imagen,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white54,
                style: BorderStyle.solid,
              ),
            ),
            child: imagen == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white70,
                        size: 40,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Agregar imagen',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(imagen.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // Widget para el mapa
  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white54),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            color: Colors.white70,
            size: 50,
          ),
          SizedBox(height: 8),
          Text(
            'Mapa interactivo - Próximamente',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 💾 Botón para guardar 
  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _guardarEmpresa,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 240, 208, 48),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Guardar Empresa',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 💾 Método para guardar la empresa 
  void _guardarEmpresa() {
    if (_formKey.currentState!.validate()) {
      
      final nuevaEmpresa = Empresa(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text,
        direccion: _direccionController.text,
        telefono: _telefonoController.text,
        email: _emailController.text,
        descripcion: _descripcionController.text,
        redesSociales: [
          if (_facebookController.text.isNotEmpty) _facebookController.text,
          if (_instagramController.text.isNotEmpty) _instagramController.text,
          if (_whatsappController.text.isNotEmpty) _whatsappController.text,
        ],
        totalReviews: 0,
        ratingPromedio: 0.0,
      );

      // Guardar en controller
      _empresaController.actualizarEmpresa(nuevaEmpresa);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Empresa registrada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );

      // Volver atrás
      Navigator.pop(context);
    }
  }
}