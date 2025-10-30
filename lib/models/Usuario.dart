import 'package:proyecto/Models/DatosPersonales.dart';
import 'package:proyecto/Models/Empresa.dart';

class Usuario extends Datospersonales {
  List<Empresa>? ListaDeEmpresas = [];

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
