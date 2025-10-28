import 'package:flutter/material.dart';
import '../componentes/mistextos.dart';

class ServicioForm extends StatefulWidget {
  final String? nombreInicial;
  final String? precioInicial;
  final String? duracionInicial;
  final String? descripcionInicial;
  final bool esEdicion;
  final Function(String, String, String, String?) onSubmit;

  const ServicioForm({
    super.key,
    this.nombreInicial,
    this.precioInicial,
    this.duracionInicial,
    this.descripcionInicial,
    required this.esEdicion,
    required this.onSubmit,
  });

  @override
  State<ServicioForm> createState() => _ServicioFormState();
}

class _ServicioFormState extends State<ServicioForm> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.esEdicion) {
      _nombreController.text = widget.nombreInicial ?? '';
      _precioController.text = widget.precioInicial ?? '';
      _duracionController.text = widget.duracionInicial ?? '';
      _descripcionController.text = widget.descripcionInicial ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiTexto(
            titulo: "Nombre del servicio",
            passw: false,
            controlador: _nombreController,
            hintText: "Ej: Corte de cabello",
          ),
          const SizedBox(height: 15),
          MiTexto(
            titulo: "Precio",
            passw: false,
            controlador: _precioController,
            keyboardType: TextInputType.number,
            hintText: "Ej: 20000",
          ),
          const SizedBox(height: 15),
          MiTexto(
            titulo: "Duración (minutos)",
            passw: false,
            controlador: _duracionController,
            keyboardType: TextInputType.number,
            hintText: "Ej: 30",
          ),
          const SizedBox(height: 15),
          MiTexto(
            titulo: "Descripción (opcional)",
            passw: false,
            controlador: _descripcionController,
            hintText: "Descripción del servicio...",
          ),
        ],
      ),
    );
  }

  // Método para obtener los datos del formulario
  Map<String, String?> getDatosFormulario() {
    return {
      'nombre': _nombreController.text,
      'precio': _precioController.text,
      'duracion': _duracionController.text,
      'descripcion': _descripcionController.text.isEmpty ? null : _descripcionController.text,
    };
  }

  // Validar formulario
  String? validarFormulario() {
    if (_nombreController.text.isEmpty) return 'El nombre es obligatorio';
    if (_precioController.text.isEmpty) return 'El precio es obligatorio';
    if (_duracionController.text.isEmpty) return 'La duración es obligatoria';
    
    final precio = double.tryParse(_precioController.text);
    if (precio == null || precio <= 0) return 'Precio debe ser un número válido';
    
    final duracion = double.tryParse(_duracionController.text);
    if (duracion == null || duracion <= 0) return 'Duración debe ser un número válido';
    
    return null;
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