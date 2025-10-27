import 'dart:developer';

import 'package:proyecto/Models/DatosPersonales.dart';
import 'package:proyecto/Models/Horario.dart';
import 'package:proyecto/Models/Vacaciones.dart';
import 'package:proyecto/Models/Empresa.dart';

class Empleado extends Datospersonales {

  DateTime? FechaDeInicio;
  DateTime? FechaActual;
  String Cargo;
  String Estado;
  String? Estacion;
  Vacaciones? vacaciones;
  Empresa empresa;
  List<Service>? ListaDeServiciosDelEmpleado;
  List<Horario>? horario;

  Empleado({
    //El super es para poder acceder a los atributos de la clase datosperonales y lo agrega autamticamente a la clase Usuarios
      required super.Id,
      required super.Cedula,
      required super.PrimerNombre,
              super.SegundoNombre,
      required super.PrimerApellido,
              super.SegundoApellido,
      required super.Telefono,
              super.Correo,
      required super.Sexo,
              super.Foto,
      required super.Rol,
      required this.FechaDeInicio,
      required this.FechaActual,
      required this.Cargo,
      required this.Estado,
               this.Estacion,
               this.vacaciones,
      required this.empresa,
               this.ListaDeServiciosDelEmpleado,
               this.horario,
  });

}