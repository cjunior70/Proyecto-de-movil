import 'package:flutter/material.dart';
import '../formularios/campo_texto_con_titulo.dart';

class FormularioLogin extends StatefulWidget {
  final TextEditingController controladorUsuario;
  final TextEditingController controladorClave;
  final String rolSeleccionado;
  final Function(String) alCambiarRol;
  final Function alPresionarLogin;

  const FormularioLogin({
    super.key,
    required this.controladorUsuario,
    required this.controladorClave,
    required this.rolSeleccionado,
    required this.alCambiarRol,
    required this.alPresionarLogin,
  });

  @override
  State<FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CampoTextoConTitulo(
          titulo: "Usuario",
          esPassword: false,
          controlador: widget.controladorUsuario,
        ),
        const SizedBox(height: 15),
        CampoTextoConTitulo(
          titulo: "Contraseña",
          esPassword: true,
          controlador: widget.controladorClave,
        ),
        const SizedBox(height: 15),
        
        // Selector de rol
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.rolSeleccionado,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6B4E71),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              items: const [
                DropdownMenuItem(
                  value: 'usuario',
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: Color(0xFF6B4E71), size: 20),
                      SizedBox(width: 10),
                      Text('Usuario'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'administrador',
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings_outlined, 
                           color: Color(0xFF6B4E71), size: 20),
                      SizedBox(width: 10),
                      Text('Administrador'),
                    ],
                  ),
                ),
              ],
              onChanged: (String? nuevoValor) {
                if (nuevoValor != null) {
                  widget.alCambiarRol(nuevoValor);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}