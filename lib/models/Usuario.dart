import 'package:proyecto/Models/DatosPersonales.dart';
import 'package:proyecto/Models/Empresa.dart';

class Usuario extends Datospersonales {
  List<Empresa>? ListaDeEmpresas;

  // 🔹 Constructor principal
  Usuario({
    required super.Id,
    required super.Cedula,
    required super.PrimerNombre,
             super.SegundoNombre,
    required super.PrimerApellido,
             super.SegundoApellido,
    required super.Telefono,
             super.Correo,
             super.Sexo,
             super.Foto,
    required super.Rol,
             this.ListaDeEmpresas,
  });

  // 🔹 Constructor vacío corregido
  Usuario.vacio()
      : ListaDeEmpresas = [],
        super(
          Id: '',
          Cedula: '',
          PrimerNombre: '',
          SegundoNombre: '',
          PrimerApellido: '',
          SegundoApellido: '',
          Telefono: '',
          Correo: '',
          Sexo: '',
          Foto: null,
          Rol: '',
        );
}
