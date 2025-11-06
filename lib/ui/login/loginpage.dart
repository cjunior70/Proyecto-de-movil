import 'package:flutter/material.dart';
import 'package:proyecto/Models/Ubicacion.dart';
import 'package:proyecto/controllers/EmpleadosController.dart';
import 'package:proyecto/controllers/ServiciosController.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:proyecto/Models/Empresa.dart';
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
      ServicioController o=new ServicioController();

      // Empresa empresaPrueba = Empresa(
      //   Id: "4be17d32-9b48-42eb-8e47-3ddee605d666", // UUID generado en frontend
      //   Nombre: "Peluquería La Estrella mas bonita",
      //   Estrellas: 4.8,
      //   Correo: "contacto@laestrellapepe.com",
      //   DescripcionUbicacion: "Calle 123 #45-67, Bogotá",
      //   WhatsApp: "3101234567",
      //   Facebook: "@laestrellaFB",
      //   Instagram: "@laestrellaIG",
      //   ImagenMiniatura: null, // si no tienes imagen de prueba
      //   ImagenGeneral: null,
      //   ComienzoLaboral: TimeOfDay(hour: 9, minute: 0), // 09:00 AM
      //   FinalizacionLaboral: TimeOfDay(hour: 18, minute: 0), // 06:00 PM
      //   usuario: Usuario(
      //     Id: "e610188b-85f8-4416-b2ff-565012ee85d6"
      //   ),
      //   ubicacion: Ubicacion(
      //     Id:"9bf7e236-34db-4026-8027-a2518a548cc5",
      //   ),
      // );

      // Empleado empleadoPrueba = Empleado(
      //   Id: "18cb2fef-53d2-4734-b0d9-1c07735b9c7e",
      //   Cedula: "123456789",
      //   PrimerNombre: "carlos",
      //   SegundoNombre: "junior",
      //   PrimerApellido: "gaviria",
      //   SegundoApellido: "marquez",
      //   Telefono: "3119876543",
      //   Correo: "andres.ramirez@empresa.com",
      //   Sexo: "M",
      //   Foto: null, // sin imagen por ahora

      //   // Fechas
      //   FechaDeInicio: DateTime(2024, 02, 01),
      //   FechaActual: DateTime.now(),

      //   // Datos laborales
      //   Cargo: "Barbero Senior",
      //   Estado: "Activo",
      //   Estacion: "Silla 3",

      //   // Vinculación a empresa (solo el ID)
      //   empresa: empresaPrueba,
  
    // );

    final servicio = Servicio(
      Id: "288603cd-bdc6-4141-8d01-d0d841415160",
      Nombre: "Corte de Cabello",
      Precio: 15000,
      TiempoPromedio: Duration(hours: 2, minutes: 40),
      Descripcion: "Corte moderno con máquina y tijera",
    );


    var situacon = await o.eliminarServicio("288603cd-bdc6-4141-8d01-d0d841415160");

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
