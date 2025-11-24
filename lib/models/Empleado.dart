import 'dart:convert';
import 'package:proyecto/Models/DatosPersonales.dart';
import 'package:proyecto/Models/Horario.dart';
import 'package:proyecto/Models/Vacaciones.dart';
import 'package:proyecto/models/Empresa.dart';
import 'package:proyecto/models/Servicio.dart';

class Empleado extends Datospersonales {
  DateTime? FechaDeInicio;
  DateTime? FechaActual;
  String? Cargo;
  String? Estado;
  String? Estacion;
  Vacaciones? vacaciones;
  Empresa? empresa;
  List<Servicio>? ListaDeServiciosDelEmpleado = [];
  List<Horario>? horario = [];

  Empleado({
    //El super es para poder acceder a los atributos de la clase datosperonales y lo agrega autamticamente a la clase Usuarios
    super.Id,
    super.Cedula,
    super.PrimerNombre,
    super.SegundoNombre,
    super.PrimerApellido,
    super.SegundoApellido,
    super.Telefono,
    super.Correo,
    super.Sexo,
    super.Foto,
    super.Rol,
    this.FechaDeInicio,
    this.FechaActual,
    this.Cargo,
    this.Estado,
    this.Estacion,
    this.vacaciones,
    this.empresa,
    this.ListaDeServiciosDelEmpleado,
    this.horario,
  });

  // conversion de odjeto a json
 Map<String, dynamic> toJson() {
  return {
    "Id": Id,
    "Cedula": Cedula,
    "PrimerNombre": PrimerNombre,
    "SegundoNombre": SegundoNombre,
    "PrimerApellido": PrimerApellido,
    "SegundoApellido": SegundoApellido,
    "Telefono": Telefono,
    "Correo": Correo,
    "Sexo": Sexo,
    "Foto": Foto != null ? base64Encode(Foto!) : null,
    //esto es para poder convertir el tipo date a string para usar json y mandarlo a base de datos : toIso8601String
    "FechaDeInicio": FechaDeInicio?.toIso8601String(),
    "FechaActual": FechaActual?.toIso8601String(),
    "Cargo": Cargo,
    "Estado": Estado,
    "Estacion": Estacion,
    "Id_Empresa": empresa!.Id,
  };
}

// Conversión de JSON a objeto Empleado
  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      Id: json["Id"],
      Cedula: json["Cedula"],
      PrimerNombre: json["PrimerNombre"],
      SegundoNombre: json["SegundoNombre"],
      PrimerApellido: json["PrimerApellido"],
      SegundoApellido: json["SegundoApellido"],
      Telefono: json["Telefono"],
      Correo: json["Correo"],
      Sexo: json["Sexo"],
      Foto: json["Foto"] != null ? base64Decode(json["Foto"]) : null,
      FechaDeInicio: json["FechaDeInicio"] != null
          ? DateTime.parse(json["FechaDeInicio"])
          : null,
      FechaActual: json["FechaActual"] != null
          ? DateTime.parse(json["FechaActual"])
          : null,
      Cargo: json["Cargo"],
      Estado: json["Estado"],
      Estacion: json["Estacion"],
      empresa: json["empresa"] != null ? Empresa(Id: json["empresa"]) : null,
    );
  }

 @override
String toString() {
  return 'Empleado{Id: $Id, Cedula: $Cedula, Nombre: $PrimerNombre $SegundoNombre $PrimerApellido $SegundoApellido, '
         'Telefono: $Telefono, Correo: $Correo, Sexo: $Sexo, Foto: ${Foto != null ? "Sí" : "No"}, '
         'FechaDeInicio: ${FechaDeInicio != null ? FechaDeInicio!.toIso8601String() : "No asignada"}, '
         'FechaActual: ${FechaActual != null ? FechaActual!.toIso8601String() : "No asignada"}, '
         'Cargo: $Cargo, Estado: $Estado, Estacion: $Estacion, '
         'EmpresaId: ${empresa?.Id ?? "No asignada"}}';
}



}
