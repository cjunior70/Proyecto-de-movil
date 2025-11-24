import 'package:flutter/material.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:uuid/uuid.dart'; // Necesario para crear nuevos IDs

// Definición del tipo de función para el callback
typedef OnServiceSave = void Function(Servicio servicio);

class FormularioServicioDialog extends StatelessWidget {
  final Servicio? servicio;
  final Uuid uuid;
  final OnServiceSave onSave;

  const FormularioServicioDialog({
    super.key,
    this.servicio,
    required this.uuid,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final nombreController = TextEditingController(text: servicio?.Nombre ?? '');
    final descripcionController = TextEditingController(text: servicio?.Descripcion ?? '');
    final precioController = TextEditingController(
      text: servicio?.Precio != null ? servicio!.Precio.toString() : '',
    );
    
    // Convertir Duration a minutos para el formulario
    final duracionMinutos = servicio?.TiempoPromedio.inMinutes ?? 30;
    final duracionController = TextEditingController(
      text: duracionMinutos.toString(),
    );

    final formKey = GlobalKey<FormState>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 35, 35, 35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.room_service_rounded,
                        color: Color.fromARGB(255, 240, 208, 48),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        servicio == null ? 'Nuevo Servicio' : 'Editar Servicio',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Campos del formulario
                _CustomTextField(
                  controller: nombreController,
                  label: 'Nombre del servicio',
                  icon: Icons.label_rounded,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                _CustomTextField(
                  controller: descripcionController,
                  label: 'Descripción',
                  icon: Icons.description_rounded,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _CustomTextField(
                        controller: precioController,
                        label: 'Precio',
                        icon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Requerido';
                          }
                          if (double.tryParse(value!) == null) {
                            return 'Número inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CustomTextField(
                        controller: duracionController,
                        label: 'Duración (min)',
                        icon: Icons.schedule_rounded,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Requerido';
                          }
                          if (int.tryParse(value!) == null) {
                            return 'Inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          
                          // Construir el objeto Servicio
                          final nuevoServicio = Servicio(
                            Id: servicio?.Id ?? uuid.v4(),
                            Nombre: nombreController.text.trim(),
                            Descripcion: descripcionController.text.trim(),
                            Precio: double.parse(precioController.text),
                            TiempoPromedio: Duration(
                              minutes: int.parse(duracionController.text),
                            ),
                          );

                          onSave(nuevoServicio);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          servicio == null ? 'Agregar' : 'Actualizar',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ TEXTFIELD PERSONALIZADO (Widget privado dentro del archivo del diálogo)
class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
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
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }
}