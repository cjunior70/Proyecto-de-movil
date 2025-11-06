import 'dart:typed_data';

import 'package:uuid/uuid.dart';

class Datospersonales {
  String? Id;
  String? Cedula;
  String? PrimerNombre;
  String? SegundoNombre;
  String? PrimerApellido;
  String? SegundoApellido;
  String? Telefono;
  String? Correo;
  String? Sexo;
  Uint8List? Foto;
  String? Rol;

  Datospersonales({
    this.Id,
    this.Cedula,
    this.PrimerNombre,
    this.SegundoNombre,
    this.PrimerApellido,
    this.SegundoApellido,
    this.Telefono,
    this.Correo,
    this.Sexo,
    this.Foto,
    this.Rol,
  });

  Datospersonales.vacio()
      : Id =null,
        Cedula = '',
        PrimerNombre = '',
        SegundoNombre = '',
        PrimerApellido = '',
        SegundoApellido = '',
        Telefono = '',
        Correo = '',
        Sexo = '',
        Foto = null,
        Rol = "";
}
