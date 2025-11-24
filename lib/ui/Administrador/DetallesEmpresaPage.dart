import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto/models/Usuario.dart';
import 'package:proyecto/controllers/EmpresaController.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ✅ Registro de empresa con diseño oscuro premium y validaciones
class DetallesEmpresaPage extends StatefulWidget {

  final Empresa empresa;   // 👈 recibir empresa

  const DetallesEmpresaPage({
    super.key,
    required this.empresa,
  });

  @override
  State<DetallesEmpresaPage> createState() => _DetallesEmpresaPageState();
}

class _DetallesEmpresaPageState extends State<DetallesEmpresaPage> {
  final _formKey = GlobalKey<FormState>();
  final EmpresaController _empresaController = EmpresaController();
  final PageController _pageController = PageController();
  int _paginaActual = 0;

  // Controladores
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  TimeOfDay _horaInicio = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _horaFin = const TimeOfDay(hour: 18, minute: 0);

  final ImagePicker _picker = ImagePicker();
  XFile? _imagenMiniatura;
  XFile? _imagenGlobal;

  bool _guardando = false;
  
  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.empresa.Nombre ?? '';
    _emailController.text = widget.empresa.Correo ?? '';
    _direccionController.text = widget.empresa.DescripcionUbicacion ?? '';
    _whatsappController.text = widget.empresa.WhatsApp ?? '';
    _facebookController.text = widget.empresa.Facebook ?? '';
    _instagramController.text = widget.empresa.Instagram ?? '';
  }

  @override
  void dispose() {
    _pageController.dispose();
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
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 240, 208, 48),
            ),
          ),
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

  void _siguientePagina() {
    if (_paginaActual < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _paginaAnterior() {
    if (_paginaActual > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _guardarEmpresa() async {

    if (!_formKey.currentState!.validate()) {
      _mostrarSnackBar('Por favor completa todos los campos requeridos', Colors.red);
      return;
    }

    setState(() {
      _guardando = true;
    });

    // Simular guardado
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('uid');

    print("Esre es id del usuario como tal, osea dueño de la empresa : ${uid}");

    if (uid == null) {
      print("❌ Error: UID es null");
      return;
    }

    final nuevaEmpresa = Empresa(
      Id: widget.empresa.Id,
      Nombre: _nombreController.text,
      DescripcionUbicacion: _direccionController.text,
      Correo: _emailController.text,
      WhatsApp: _whatsappController.text,  // Aquí va el WhatsApp
      Facebook: _facebookController.text,  // Facebook
      Instagram: _instagramController.text, // Instagram
      usuario: Usuario(Id: uid) as Usuario?,
      // totalReviews: 0,
      // ratingPromedio: 0.0,
    );

    _empresaController.actualizarEmpresa(nuevaEmpresa);

    setState(() {
      _guardando = false;
    });

    _mostrarSnackBar('Empresa actualizada exitosamente', Colors.green);

    // Volver con la nueva empresa
    Navigator.pop(context, nuevaEmpresa);
  }

  void _mostrarSnackBar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
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
              Color.fromARGB(255, 50, 50, 50),
              Color.fromARGB(255, 70, 70, 70),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Indicador de progreso
              _buildProgressIndicator(),

              // Contenido con PageView
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _paginaActual = index;
                      });
                    },
                    children: [
                      _buildPagina1(),
                      _buildPagina2(),
                      _buildPagina3(),
                    ],
                  ),
                ),
              ),

              // Botones de navegación
              _buildBotonesNavegacion(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Registrar",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Nueva Empresa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _paginaActual;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color.fromARGB(255, 240, 208, 48)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ========== PÁGINA 1: Información Básica ==========
  Widget _buildPagina1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTituloPagina('Información Básica', Icons.business_rounded),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _nombreController,
            label: 'Nombre de la empresa',
            icon: Icons.store_rounded,
            validator: (value) =>
                value?.isEmpty ?? true ? 'El nombre es obligatorio' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Correo Electrónico',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'El correo es obligatorio';
              if (!value!.contains('@')) return 'Correo inválido';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _telefonoController,
            label: 'Teléfono',
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'El teléfono es obligatorio';
              if (!RegExp(r'^\d{7,10}$').hasMatch(value!)) {
                return 'Número inválido (7-10 dígitos)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _direccionController,
            label: 'Dirección',
            icon: Icons.location_on_rounded,
            maxLines: 2,
            validator: (value) =>
                value?.isEmpty ?? true ? 'La dirección es obligatoria' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descripcionController,
            label: 'Descripción del negocio',
            icon: Icons.description_rounded,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // ========== PÁGINA 2: Horarios e Imágenes ==========
  Widget _buildPagina2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTituloPagina('Horarios e Imágenes', Icons.schedule_rounded),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTimePicker(
                  label: 'Hora de Inicio',
                  time: _horaInicio,
                  onTap: () => _seleccionarHora(true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimePicker(
                  label: 'Hora de Cierre',
                  time: _horaFin,
                  onTap: () => _seleccionarHora(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Imágenes del Negocio',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildImageUploader(
                  label: 'Miniatura',
                  imagen: _imagenMiniatura,
                  onTap: () => _seleccionarImagen(true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildImageUploader(
                  label: 'Portada',
                  imagen: _imagenGlobal,
                  onTap: () => _seleccionarImagen(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== PÁGINA 3: Redes Sociales ==========
  Widget _buildPagina3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTituloPagina('Redes Sociales', Icons.share_rounded),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _facebookController,
            label: 'Facebook (opcional)',
            icon: Icons.facebook_rounded,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _instagramController,
            label: 'Instagram (opcional)',
            icon: Icons.camera_alt_rounded,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _whatsappController,
            label: 'WhatsApp (opcional)',
            icon: Icons.chat_rounded,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildTituloPagina(String titulo, IconData icono) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icono,
            color: const Color.fromARGB(255, 240, 208, 48),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

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
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 240, 208, 48),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

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
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.access_time_rounded,
                  color: Color.fromARGB(255, 240, 208, 48),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: imagen == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Colors.white.withOpacity(0.5),
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Agregar',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
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

  Widget _buildBotonesNavegacion() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          if (_paginaActual > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _paginaAnterior,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Anterior',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          if (_paginaActual > 0) const SizedBox(width: 16),
          Expanded(
            flex: _paginaActual == 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _guardando
                  ? null
                  : _paginaActual < 2
                      ? _siguientePagina
                      : _guardarEmpresa,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: _guardando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _paginaActual < 2 ? 'Siguiente' : 'Guardar Empresa',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}