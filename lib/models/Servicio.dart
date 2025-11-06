class Servicio {
  String Id;
  String? Nombre;
  double? Precio;
  Duration TiempoPromedio;
  String? Descripcion;

  Servicio({
    required this.Id,
    this.Nombre,
    this.Precio,
    required this.TiempoPromedio,
    this.Descripcion,
  });

   /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      "Id": Id,
      "Nombre": Nombre,
      "Precio": Precio,
      "Tiempo": _durationToString(TiempoPromedio), // Se envía como HH:mm:ss
      "Descripcion": Descripcion,
    };
  }

  /// Convertimos Duration a string "HH:mm:ss"
  String _durationToString(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  /// FROM JSON
  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      Id: json["Id"],
      Nombre: json["Nombre"],
      Precio: json["Precio"] != null ? double.tryParse(json["Precio"].toString()) : null,
      TiempoPromedio: json["Tiempo"] != null
          ? (json["Tiempo"] is Duration
              ? json["Tiempo"]
              : Duration(
                  hours: int.parse(json["Tiempo"].split(":")[0]),
                  minutes: int.parse(json["Tiempo"].split(":")[1]),
                  seconds: int.parse(json["Tiempo"].split(":")[2]),
                ))
          : Duration.zero,
      Descripcion: json["Descripcion"],
    );
  }

   /// Convertimos "HH:mm:ss" a Duration
  Duration _stringToDuration(String value) {
    final parts = value.split(":");
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  /// OVERRIDE ToString
  @override
  String toString() {
    return "Servicio(Id: $Id, Nombre: $Nombre, Precio: $Precio, TiempoPromedio: ${_durationToString(TiempoPromedio)}, Descripcion: $Descripcion)";
  }
}
