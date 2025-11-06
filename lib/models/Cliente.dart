import 'dart:convert';

import 'package:proyecto/Models/Reservacion.dart';
import 'package:proyecto/Models/DatosPersonales.dart';

class Cliente extends Datospersonales {
  List<Reservacion> ListaDeReservaciones;

  Cliente({
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
    this.ListaDeReservaciones = const [],
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
      // si no quieres enviar foto cuando es null, deja null
      "Foto": Foto != null ? base64Encode(Foto!) : null,
    };
  }

  // conversion de json a odjeto
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
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
    );
  }

  @override
  String toString() {
    return 'Cliente{Id: $Id, Cedula: $Cedula, Nombre: $PrimerNombre $SegundoNombre $PrimerApellido $SegundoApellido, Telefono: $Telefono, Correo: $Correo, Sexo: $Sexo, Foto: ${Foto != null ? "Sí" : "No"}}';
  }
}
