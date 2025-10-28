import 'package:proyecto/Models/Usuario.dart';
import 'package:proyecto/Models/Empresa.dart';

class UsuarioController {
  Usuario? _usuario; // único usuario en memoria

  // ✅ Guardar usuario
  void guardarUsuario(Usuario nuevoUsuario) {
    if (_usuario != null) {
      print("⚠️ Ya hay un usuario registrado. Usa actualizarUsuario().");
      return;
    }

    _usuario = nuevoUsuario;
    print("✅ Usuario guardado correctamente: ${_usuario!.Cedula}");
    print("✅ Usuario guardado correctamente: ${_usuario!.PrimerNombre}");
    print("✅ Usuario guardado correctamente: ${_usuario!.SegundoNombre}");
    print("✅ Usuario guardado correctamente: ${_usuario!.PrimerApellido}");
    print("✅ Usuario guardado correctamente: ${_usuario!.SegundoApellido}");
    print("✅ Usuario guardado correctamente: ${_usuario!}");
  }

  // ✅ Obtener usuario actual
  Usuario? obtenerUsuario() {
    if (_usuario == null) {
      
      print("⚠️ No hay usuario registrado actualmente.");
      return null;
    }
    
    return _usuario;
  }

  // ✅ Actualizar usuario
  void actualizarUsuario(Usuario usuarioActualizado) {
    if (_usuario == null) {
      print("⚠️ No hay usuario registrado para actualizar.");
      return;
    }

    if (_usuario!.Id != usuarioActualizado.Id) {
      print("⚠️ El ID no coincide con el usuario actual.");
      return;
    }

    _usuario = usuarioActualizado;
    print("🔄 Usuario actualizado correctamente: ${_usuario!.PrimerNombre}");
  }

  // ✅ Eliminar usuario
  void eliminarUsuario() {
    if (_usuario == null) {
      print("⚠️ No hay usuario registrado para eliminar.");
      return;
    }

    print("🗑️ Usuario eliminado: ${_usuario!.PrimerNombre}");
    _usuario = null;
  }

  // ✅ Agregar empresa al usuario
  void agregarEmpresa(Empresa empresa) {
    if (_usuario == null) {
      print("⚠️ No hay usuario registrado para asignarle una empresa.");
      return;
    }

    _usuario!.ListaDeEmpresas ??= [];
    _usuario!.ListaDeEmpresas!.add(empresa);

    print("🏢 Empresa agregada al usuario: ${empresa.Nombre}");
  }

  // ✅ Mostrar resumen del usuario
  void mostrarResumen() {
    if (_usuario == null) {
      print("⚠️ No hay usuario registrado.");
      return;
    }

    print("""
👤 USUARIO REGISTRADO
🆔 ID: ${_usuario!.Id}
🪪 Cédula: ${_usuario!.Cedula}
👨‍💼 Nombre: ${_usuario!.PrimerNombre} ${_usuario!.PrimerApellido}
📧 Correo: ${_usuario!.Correo ?? 'No definido'}
🏢 Empresas asociadas: ${_usuario!.ListaDeEmpresas?.length ?? 0}
""");
  }
}
