import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto/Models/Cliente.dart';
import 'package:proyecto/Controllers/ClienteController.dart';
import 'package:proyecto/controllers/UsuarioController.dart';
import 'package:proyecto/Models/Usuario.dart';
import 'dart:io';
import 'package:proyecto/ui/login/loginpage.dart';

class Registro extends StatefulWidget {
  final String rol;

  const Registro({super.key, required this.rol});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cedulaCtrl = TextEditingController();
  final TextEditingController primerNombreCtrl = TextEditingController();
  final TextEditingController segundoNombreCtrl = TextEditingController();
  final TextEditingController primerApellidoCtrl = TextEditingController();
  final TextEditingController segundoApellidoCtrl = TextEditingController();
  final TextEditingController correoCtrl = TextEditingController();

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

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      if (widget.rol == "Administrador") {
        // Guardar cliente usando singleton
        Usuario nuevoUsuario = Usuario(
          Id: "c1",
          Cedula: cedulaCtrl.text,
          PrimerNombre: primerNombreCtrl.text,
          SegundoNombre: segundoNombreCtrl.text,
          PrimerApellido: primerApellidoCtrl.text,
          SegundoApellido: segundoApellidoCtrl.text,
          Telefono: "12345",
          Correo: correoCtrl.text,
          Sexo: sexoSeleccionado,
          // Foto: foto,
          Rol: widget.rol,
        );

        UsuarioController().guardarUsuario(nuevoUsuario);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado ✅')),
        );

        // Ir a página de login (o donde quieras)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
      else{
        Cliente nuevoCliente = Cliente(
          Id: "c1",
          Cedula: cedulaCtrl.text,
          PrimerNombre: primerNombreCtrl.text,
          SegundoNombre: segundoNombreCtrl.text,
          PrimerApellido: primerApellidoCtrl.text,
          SegundoApellido: segundoApellidoCtrl.text,
          Telefono: "12345",
          Correo: correoCtrl.text,
          Sexo: sexoSeleccionado,
          // Foto: foto,
          Rol: widget.rol,
          ListaDeReservaciones: null,
        );

        ClienteController().guardarCliente(nuevoCliente);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente registrado ✅')),
        );

        // Ir a página de login (o donde quieras)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario de Registro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: cedulaCtrl,
                decoration: const InputDecoration(labelText: 'Cédula *'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'La cédula es obligatoria';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: primerNombreCtrl,
                decoration: const InputDecoration(labelText: 'Primer Nombre *'),
                validator: (value) => value == null || value.isEmpty ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: segundoNombreCtrl,
                decoration: const InputDecoration(labelText: 'Segundo Nombre'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: primerApellidoCtrl,
                decoration: const InputDecoration(labelText: 'Primer Apellido *'),
                validator: (value) => value == null || value.isEmpty ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: segundoApellidoCtrl,
                decoration: const InputDecoration(labelText: 'Segundo Apellido'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: correoCtrl,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: sexoSeleccionado,
                decoration: const InputDecoration(labelText: 'Sexo *'),
                items: const [
                  DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                ],
                onChanged: (valor) => setState(() => sexoSeleccionado = valor),
                validator: (value) => value == null ? 'Seleccione un sexo' : null,
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    if (foto != null)
                      CircleAvatar(radius: 50, backgroundImage: FileImage(foto!))
                    else
                      const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                    TextButton.icon(
                      onPressed: _seleccionarFoto,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Seleccionar foto'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: _guardarFormulario,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
