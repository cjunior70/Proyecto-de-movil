class Ubicacion {
  String? Id;
  double? Latitud;
  double? Longitud;

  Ubicacion({
    this.Id,
    this.Latitud,
    this.Longitud,
  });

  Ubicacion.vacio()
      : Id = "",
        Latitud = null,
        Longitud = null;

  /// ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return {
      "Id": Id,
      "Latitud": Latitud,
      "Longitud": Longitud,
    };
  }

  /// ---------- FROM JSON ----------
  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      Id: json["Id"],
      Latitud: json["Latitud"] != null
          ? double.tryParse(json["Latitud"].toString())
          : null,
      Longitud: json["Longitud"] != null
          ? double.tryParse(json["Longitud"].toString())
          : null,
    );
  }

  /// ---------- TO STRING ----------
  @override
  String toString() {
    return "Ubicacion{ Id: $Id, Latitud: $Latitud, Longitud: $Longitud }";
  }
}
