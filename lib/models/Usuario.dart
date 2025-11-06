import 'dart:convert';

import 'package:proyecto/Models/DatosPersonales.dart';
import 'package:proyecto/Models/Empresa.dart';

class Usuario extends Datospersonales {
  List<Empresa> ListaDeEmpresas;


  // 🔹 Constructor principal
  Usuario({
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
    this.ListaDeEmpresas = const [],
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
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
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
    return 'Usuario{Id: $Id, Cedula: $Cedula, Nombre: $PrimerNombre $SegundoNombre $PrimerApellido $SegundoApellido, Telefono: $Telefono, Correo: $Correo, Sexo: $Sexo, Foto: ${Foto != null ? "Sí" : "No"}}';
  }

}


