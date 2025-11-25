import 'package:flutter/material.dart';
import 'package:proyecto/models/Empresa.dart';  // ✅ Asegúrate que sea la misma ruta
import 'package:proyecto/models/Empleado.dart'; // ✅ Asegúrate que sea la misma ruta
import 'package:proyecto/controllers/EmpleadosController.dart';
import 'package:uuid/uuid.dart';

/// ✅ FORMULARIO DE EMPLEADO - Componente Separado
class FormularioEmpleado extends StatefulWidget {
  final Empresa empresa;
  final Empleado? empleado;
  final Function() onSuccess;

  const FormularioEmpleado({
    super.key,
    required this.empresa,
    this.empleado,
    required this.onSuccess,
  });

  @override
  State<FormularioEmpleado> createState() => _FormularioEmpleadoState();
}

class _FormularioEmpleadoState extends State<FormularioEmpleado> {
  final _formKey = GlobalKey<FormState>();
  final EmpleadoController _empleadoController = EmpleadoController();
  final _uuid = const Uuid();

  // Controladores
  late final TextEditingController _primerNombreController;
  late final TextEditingController _segundoNombreController;
  late final TextEditingController _primerApellidoController;
  late final TextEditingController _segundoApellidoController;
  late final TextEditingController _cedulaController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _correoController;
  late final TextEditingController _cargoController;

  late String _sexoSeleccionado;
  late String _estadoSeleccionado;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controladores con datos del empleado si existe
    _primerNombreController = TextEditingController(
      text: widget.empleado?.PrimerNombre ?? '',
    );
    _segundoNombreController = TextEditingController(
      text: widget.empleado?.SegundoNombre ?? '',
    );
    _primerApellidoController = TextEditingController(
      text: widget.empleado?.PrimerApellido ?? '',
    );
    _segundoApellidoController = TextEditingController(
      text: widget.empleado?.SegundoApellido ?? '',
    );
    _cedulaController = TextEditingController(
      text: widget.empleado?.Cedula ?? '',
    );
    _telefonoController = TextEditingController(
      text: widget.empleado?.Telefono ?? '',
    );
    _correoController = TextEditingController(
      text: widget.empleado?.Correo ?? '',
    );
    _cargoController = TextEditingController(
      text: widget.empleado?.Cargo ?? '',
    );

    _sexoSeleccionado = widget.empleado?.Sexo ?? 'Masculino';
    _estadoSeleccionado = widget.empleado?.Estado ?? 'Activo';
  }

  @override
  void dispose() {
    _primerNombreController.dispose();
    _segundoNombreController.dispose();
    _primerApellidoController.dispose();
    _segundoApellidoController.dispose();
    _cedulaController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      // Crear o actualizar empleado
      final nuevoEmpleado = Empleado(
        Id: widget.empleado?.Id ?? _uuid.v4(),
        Cedula: _cedulaController.text.trim(),
        PrimerNombre: _primerNombreController.text.trim(),
        SegundoNombre: _segundoNombreController.text.trim().isEmpty
            ? null
            : _segundoNombreController.text.trim(),
        PrimerApellido: _primerApellidoController.text.trim(),
        SegundoApellido: _segundoApellidoController.text.trim().isEmpty
            ? null
            : _segundoApellidoController.text.trim(),
        Telefono: _telefonoController.text.trim(),
        Correo: _correoController.text.trim(),
        Sexo: _sexoSeleccionado,
        Cargo: _cargoController.text.trim(),
        Estado: _estadoSeleccionado,
        FechaDeInicio: widget.empleado?.FechaDeInicio ?? DateTime.now(),
        FechaActual: DateTime.now(),
        Rol: 'Empleado', // ✅ Agregar rol por defecto
        empresa: Empresa(Id: widget.empresa.Id),
      );

      bool exito = false;

      if (widget.empleado == null) {
        // ✅ AGREGAR
        exito = await _empleadoController.guardarEmpleado(nuevoEmpleado);
      } else {
        // ✅ EDITAR
        exito = await _empleadoController.actualizarEmpleado(nuevoEmpleado);
      }

      if (exito) {
        if (mounted) {
          Navigator.pop(context);
          widget.onSuccess();
          _mostrarSnackBar(
            widget.empleado == null
                ? '✅ Empleado agregado exitosamente'
                : '✅ Empleado actualizado',
            Colors.green,
          );
        }
      } else {
        _mostrarSnackBar('Error al guardar el empleado', Colors.red);
      }
    } catch (e) {
      //print('❌ Error guardando empleado: $e');
      _mostrarSnackBar('Error al guardar el empleado', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 35, 35, 35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildNombresRow(),
                const SizedBox(height: 16),
                _buildApellidosRow(),
                const SizedBox(height: 16),
                _buildCedulaTelefonoRow(),
                const SizedBox(height: 16),
                _buildCorreo(),
                const SizedBox(height: 16),
                _buildCargoSexoRow(),
                const SizedBox(height: 16),
                _buildEstado(),
                const SizedBox(height: 24),
                _buildBotones(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ HEADER
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 240, 208, 48).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Color.fromARGB(255, 240, 208, 48),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.empleado == null ? 'Nuevo Empleado' : 'Editar Empleado',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ NOMBRES
  Widget _buildNombresRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _primerNombreController,
            label: 'Primer Nombre',
            icon: Icons.person_outline,
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTextField(
            controller: _segundoNombreController,
            label: 'Segundo Nombre',
            icon: Icons.person_outline,
          ),
        ),
      ],
    );
  }

  // ✅ APELLIDOS
  Widget _buildApellidosRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _primerApellidoController,
            label: 'Primer Apellido',
            icon: Icons.badge_outlined,
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTextField(
            controller: _segundoApellidoController,
            label: 'Segundo Apellido',
            icon: Icons.badge_outlined,
          ),
        ),
      ],
    );
  }

  // ✅ CÉDULA Y TELÉFONO
  Widget _buildCedulaTelefonoRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _cedulaController,
            label: 'Cédula',
            icon: Icons.credit_card_rounded,
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTextField(
            controller: _telefonoController,
            label: 'Teléfono',
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
        ),
      ],
    );
  }

  // ✅ CORREO
  Widget _buildCorreo() {
    return _buildTextField(
      controller: _correoController,
      label: 'Correo Electrónico',
      icon: Icons.email_rounded,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Requerido';
        if (!value!.contains('@')) return 'Correo inválido';
        return null;
      },
    );
  }

  // ✅ CARGO Y SEXO
  Widget _buildCargoSexoRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _cargoController,
            label: 'Cargo',
            icon: Icons.work_rounded,
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdown(
            label: 'Sexo',
            value: _sexoSeleccionado,
            items: ['Masculino', 'Femenino'],
            icon: Icons.wc_rounded,
            onChanged: (value) {
              setState(() {
                _sexoSeleccionado = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  // ✅ ESTADO
  Widget _buildEstado() {
    return _buildDropdown(
      label: 'Estado',
      value: _estadoSeleccionado,
      items: ['Activo', 'Inactivo'],
      icon: Icons.toggle_on_rounded,
      onChanged: (value) {
        setState(() {
          _estadoSeleccionado = value!;
        });
      },
    );
  }

  // ✅ BOTONES
  Widget _buildBotones() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _guardando ? null : () => Navigator.pop(context),
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
            onPressed: _guardando ? null : _guardar,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 240, 208, 48),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                    widget.empleado == null ? 'Agregar' : 'Actualizar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // ✅ WIDGETS AUXILIARES
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: const Color.fromARGB(255, 40, 40, 40),
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
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }
}