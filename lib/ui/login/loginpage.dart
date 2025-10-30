import 'package:flutter/material.dart';
import 'package:proyecto/ui/Registro/Registro.dart';
import 'package:proyecto/ui/home/homepageAdmin.dart';
import 'package:proyecto/ui/home/UsuarioHome.dart';


import '../componentes/Login/tarjetas/tarjeta_login.dart';
import '../componentes/Login/encabezados/encabezado_bienvenida.dart';
import '../componentes/Login/formularios/formulario_login.dart';
import '../componentes/Login/botones/boton_primario.dart';
import '../componentes/Login/navegacion/enlaces_inferiores.dart';
import '../componentes/Login/dialogos/dialogo_eleccion_registro.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controladorUsuario = TextEditingController();
  final TextEditingController controladorClave = TextEditingController();
  String rolSeleccionado = 'usuario';

  void _iniciarSesion() {
    if (controladorUsuario.text == 'papasconquesos' && controladorClave.text == 'yarkit123') {
      if (rolSeleccionado == "usuario") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UsuarioHome()),
        );
      } else if (rolSeleccionado == "administrador") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomepageAdmin()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Usuario o contraseña incorrectos'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _mostrarOpcionesRegistro(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogoEleccionRegistro(
          alPresionarAdministrador: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Registro(rol: "Administrador")),
            );
          },
          alPresionarCliente: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Registro(rol: "Cliente")),
            );
          },
        );
      },
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
              Color.fromARGB(255, 43, 43, 43),
              Color.fromARGB(255, 144, 144, 144),
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
                    TarjetaLogin(
                      hijo: Column(
                        children: [
                          const EncabezadoBienvenida(),
                          const SizedBox(height: 35),
                          
                          FormularioLogin(
                            controladorUsuario: controladorUsuario,
                            controladorClave: controladorClave,
                            rolSeleccionado: rolSeleccionado,
                            alCambiarRol: (nuevoRol) {
                              setState(() {
                                rolSeleccionado = nuevoRol;
                              });
                            },
                            alPresionarLogin: _iniciarSesion,
                          ),
                          const SizedBox(height: 30),
                          
                          BotonPrimario(
                            texto: "Iniciar Sesión",
                            alPresionar: _iniciarSesion,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    EnlacesInferiores(
                      alPresionarRegistro: () => _mostrarOpcionesRegistro(context),
                      alPresionarContacto: () {
                        // TODO: Implementar contacto
                      },
                      alPresionarInfo: () {
                        // TODO: Implementar más información
                      },
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