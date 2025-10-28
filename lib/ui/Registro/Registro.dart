import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto/Models/Cliente.dart';
import 'package:proyecto/Models/Usuario.dart';
import 'package:proyecto/controllers/ClienteController.dart';
import 'package:proyecto/controllers/UsuarioController.dart';
import 'dart:io';

import 'package:proyecto/ui/login/loginpage.dart';

class Registro extends StatefulWidget {
  final rol;

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

      if(widget.rol == "Administrador")
        {

          UsuarioController usuarioController=new UsuarioController();

          Usuario usuario= new Usuario(Id: "2", Cedula: cedulaCtrl.text, PrimerNombre: primerNombreCtrl.text, SegundoNombre: segundoNombreCtrl.text , PrimerApellido: primerApellidoCtrl.text, SegundoApellido: segundoApellidoCtrl.text , Telefono: "1232",Correo: null, Sexo: sexoSeleccionado, Foto: null, Rol: widget.rol);
          usuarioController.guardarUsuario(usuario);

          Usuario? usuarioGuardado = usuarioController.obtenerUsuario();
          if (usuarioGuardado != null) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Formulario válido ✅ | Rol: ${widget.rol}')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
          else{
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Una disculpa, parece que hubo un error logico")),
            );
          }
        }
        else
        {

          ClienteController clienteController=new ClienteController();

          Cliente nuevoCliente= new Cliente(Id: "4", Cedula: cedulaCtrl.text, PrimerNombre: primerNombreCtrl.text, SegundoNombre: segundoNombreCtrl.text , PrimerApellido: primerApellidoCtrl.text, SegundoApellido: segundoApellidoCtrl.text , Telefono: "123245", Sexo: sexoSeleccionado, Rol: widget.rol);

          clienteController.guardarCliente(nuevoCliente);

          Cliente? clienteGuardado = clienteController.obtenerCliente();

          if (clienteGuardado != null) {

             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Formulario válido ✅ | Rol: ${widget.rol}')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }

        };

      
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
              // Cédula (Obligatoria)
              TextFormField(
                controller: cedulaCtrl,
                decoration: const InputDecoration(labelText: 'Cédula *'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La cédula es obligatoria';
                  }
                  if (value.length < 5) {
                    return 'La cédula debe tener al menos 5 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Primer Nombre (Obligatorio)
              TextFormField(
                controller: primerNombreCtrl,
                decoration: const InputDecoration(labelText: 'Primer Nombre *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El primer nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Segundo Nombre (Opcional)
              TextFormField(
                controller: segundoNombreCtrl,
                decoration: const InputDecoration(labelText: 'Segundo Nombre'),
              ),
              const SizedBox(height: 10),

              // Primer Apellido (Obligatorio)
              TextFormField(
                controller: primerApellidoCtrl,
                decoration:
                    const InputDecoration(labelText: 'Primer Apellido *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El primer apellido es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Segundo Apellido (Opcional)
              TextFormField(
                controller: segundoApellidoCtrl,
                decoration:
                    const InputDecoration(labelText: 'Segundo Apellido'),
              ),
              const SizedBox(height: 10),

              // Correo (Opcional)
              TextFormField(
                controller: correoCtrl,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              // // Telefono (Opcional)
              // TextFormField(
              //   controller: correoCtrl,
              //   decoration: const InputDecoration(labelText: 'Telefono'),
              //   keyboardType: TextInputType.emailAddress,
              // ),
              // const SizedBox(height: 10),

              // Sexo (Obligatorio)
              DropdownButtonFormField<String>(
                value: sexoSeleccionado,
                decoration: const InputDecoration(labelText: 'Sexo *'),
                items: const [
                  DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                ],
                onChanged: (valor) {
                  setState(() {
                    sexoSeleccionado = valor;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un sexo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Foto (Opcional)
              Center(
                child: Column(
                  children: [
                    if (foto != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(foto!),
                      )
                    else
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                    TextButton.icon(
                      onPressed: _seleccionarFoto,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Seleccionar foto'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Botón guardar
              Center(
                child: ElevatedButton(
                  onPressed: _guardarFormulario,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
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
