import 'dart:typed_data';

class Datospersonales {
  String Id;
  String Cedula;
  String PrimerNombre;
  String? SegundoNombre;
  String PrimerApellido;
  String? SegundoApellido;
  String Telefono;
  String? Correo;
  String Sexo;
  Uint8List? Foto; // el signo ? permite que sea opcional (puede ser null)
  String Rol;

  //Constructor
  Datospersonales({
    required this.Id,
    required this.Cedula,
    required this.PrimerNombre,
             this.SegundoNombre,
    required this.PrimerApellido,
             this.SegundoApellido,
    required this.Telefono,
             this.Correo,
    required this.Sexo,
             this.Foto,
    required this.Rol,
  });

  // Constructor vacío es para que los datos este por defecto solos porque el required no permite que este sin nd
  Datospersonales.vacio()
      : Id = '',
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