import 'package:flutter/material.dart';
import 'package:proyecto/Controllers/ClienteController.dart';
import 'package:proyecto/Models/Cliente.dart';
import 'package:proyecto/ui/home/UsuarioHome.dart';

class ClienteDetallePage extends StatefulWidget {
  const ClienteDetallePage({super.key});

  @override
  State<ClienteDetallePage> createState() => _ClienteDetallePageState();
}

class _ClienteDetallePageState extends State<ClienteDetallePage> {
  Cliente? cliente;

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
    // Obtener cliente desde singleton
    cliente = ClienteController().obtenerCliente();

    if (cliente != null) {
      // Inicializar campos con datos actuales
      cedulaCtrl.text = cliente!.Cedula;
      primerNombreCtrl.text = cliente!.PrimerNombre;
      segundoNombreCtrl.text = cliente!.SegundoNombre ?? "";
      primerApellidoCtrl.text = cliente!.PrimerApellido;
      segundoApellidoCtrl.text = cliente!.SegundoApellido ?? "";
      telefonoCtrl.text = cliente!.Telefono ?? "";
      correoCtrl.text = cliente!.Correo ?? "";
      sexoSeleccionado = cliente!.Sexo;
    }
  }

  void _guardarCambios() {
    if (cliente != null) {
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
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Datos actualizados')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cliente == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Datos del Cliente")),
        body: const Center(child: Text("No hay cliente registrado.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Datos del Cliente"), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("Cédula", cedulaCtrl),
            _buildTextField("Primer Nombre", primerNombreCtrl),
            _buildTextField("Segundo Nombre", segundoNombreCtrl),
            _buildTextField("Primer Apellido", primerApellidoCtrl),
            _buildTextField("Segundo Apellido", segundoApellidoCtrl),
            _buildTextField("Teléfono", telefonoCtrl),
            _buildTextField("Correo", correoCtrl),
            _buildSexoDropdown(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _guardarCambios(); // Esto guarda los cambios y refresca la UI
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsuarioHome()),
                );
              },
              child: const Text("Guardar cambios"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSexoDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: sexoSeleccionado,
        decoration: const InputDecoration(
          labelText: "Sexo",
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
          DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
          DropdownMenuItem(value: 'Otro', child: Text('Otro')),
        ],
        onChanged: (valor) => setState(() => sexoSeleccionado = valor),
      ),
    );
  }
}
