import 'package:flutter/material.dart';
import 'package:proyecto/Models/Ubicacion.dart';
import 'package:proyecto/controllers/EmpleadosController.dart';
import 'package:proyecto/controllers/ReservacionController.dart';
import 'package:proyecto/controllers/ServiciosController.dart';
import 'package:proyecto/controllers/UbicacionController.dart';
import 'package:proyecto/models/Cliente.dart';
import 'package:proyecto/models/Contabilidad.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Reservacion.dart';
import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/models/Usuario.dart';
import 'package:proyecto/ui/Registro/Registro.dart';
import 'package:proyecto/ui/componentes/mistextos.dart';
import 'package:uuid/uuid.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController txtUsuario = TextEditingController();
  final TextEditingController txtClave = TextEditingController();
  String rolSeleccionado = 'usuario';

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  void _testConnection() async {
    try {
      ReservacionController o=new ReservacionController();

    Reservacion testReservacion = Reservacion(
      Id: "36b83a3f-6e8d-4c86-bb88-430ca6700ca7",
      Creacion: DateTime.now(),
      Fecha: DateTime(2025, 3, 14, 15, 30),
      Total: 450000,
      Estado: "Espera..",
      Comentario: "Cliente pidió corte + barba.",
      Estrellas: 5,
      empresa: Empresa(Id: "4be17d32-9b48-42eb-8e47-3ddee605d666"),
      cliente: Cliente(Id: "3fee39e0-d29b-4d04-bd3b-f1241585b829"),
    );

    var situacon = await o.eliminarReservacion("36b83a3f-6e8d-4c86-bb88-430ca6700ca7");

    print("ESTADO DE LA OPERACION: $situacon");

    }
    catch(e)
    {
      print("Erro afuera de todo lo conocido");
    }
  }

  void _login() {
    if (txtUsuario.text == 'papasconquesos' &&
        txtClave.text == 'yarkit123') {
      if (rolSeleccionado == "usuario") {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const UsuarioHome()),
        // );
      } else if (rolSeleccionado == "administrador") {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomepageAdmin()),
        // );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Usuario o contraseña incorrectos'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

 void mostrarOpcionesRegistro(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Selecciona el tipo de registro",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text("Administrador"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // 👉 Aquí podrías navegar a la pantalla de registro de administrador
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Registro como Administrador")),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Registro(rol:"Administrador")),
                  );
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text("Cliente"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // 👉 Aquí podrías navegar a la pantalla de registro de cliente
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Registro como Cliente")),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Registro(rol:"Cliente")),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 43, 43, 43),
              const Color.fromARGB(255, 144, 144, 144),
             
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                       
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 240, 208, 48),
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              "https://cdn-icons-png.flaticon.com/512/6703/6703553.png",
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const SizedBox(height: 25),

                          const Text(
                            "¡Bienvenido!",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B4E71),
                            ),
                          ),
                          const SizedBox(height: 8),

                          const Text(
                            "¿Cómo está tu corte hoy?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 35),

                          // Campos de entrada
                          MiTexto(
                            titulo: "Usuario",
                            passw: false,
                            controlador: txtUsuario,
                          ),
                          const SizedBox(height: 15),

                          MiTexto(
                            titulo: "Contraseña",
                            passw: true,
                            controlador: txtClave,
                          ),
                          const SizedBox(height: 15),

                          // Selector de rol mejorado
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: rolSeleccionado,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xFF6B4E71),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'usuario',
                                    child: Row(
                                      children: [
                                        Icon(Icons.person_outline,
                                            color: Color(0xFF6B4E71), size: 20),
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
                                  setState(() {
                                    rolSeleccionado = nuevoValor!;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Botón de login mejorado
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 240, 208, 48),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shadowColor:
                                    const Color.fromARGB(255, 240, 208, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "Iniciar Sesión",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Enlaces inferiores con mejor diseño
                    Column(
                      children: [
                        TextButton(
                          onPressed: () => mostrarOpcionesRegistro(context),
                          child: const Text(
                            "Registrarse",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Contáctanos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Más información",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}
