import 'dart:convert';

RutinaSesionDb routineSessionFromJson(String str) =>
    RutinaSesionDb.fromJson(json.decode(str));

String routineSessionToJson(RutinaSesionDb data) => json.encode(data.toJson());

class RutinaSesionDb {
  // Nombres de las columnas de la tabla
  static const String tabla = 'routine_session';
  static const String columnaId = 'id';
  static const String columnaRutinaId = 'rutina_id';
  static const String columnaHoraInicio = 'hora_inicio';
  static const String columnaHoraFin = 'hora_fin';
  static const String columnaEstado = 'estado';
  static const String columnaFechaCreacion = 'fecha_creacion';

  final String id;
  final String rutinaId;
  final String? horaInicio;
  final String? horaFin;
  final String estado;
  final String fechaCreacion;

  RutinaSesionDb({
    required this.id,
    required this.rutinaId,
    this.horaInicio,
    this.horaFin,
    required this.estado,
    required this.fechaCreacion,
  });

  // como saco el tiempo que tomo realizar esta routina_session
  double get duracion {
    if (horaInicio == null || horaFin == null) {
      return 0.0; // Retornar 0 si algún timestamp es nulo
    }

    try {
      final inicio = DateTime.parse(horaInicio!);
      final fin = DateTime.parse(horaFin!);
      return fin.difference(inicio).inMinutes.toDouble();
    } catch (e) {
      // Si hay error al parsear las fechas, retornar 0
      return 0.0;
    }
  }

  RutinaSesionDb copyWith({
    String? id,
    String? rutinaId,
    String? horaInicio,
    String? horaFin,
    String? estado,
    String? fechaCreacion,
  }) =>
      RutinaSesionDb(
        id: id ?? this.id,
        rutinaId: rutinaId ?? this.rutinaId,
        horaInicio: horaInicio ?? this.horaInicio,
        horaFin: horaFin ?? this.horaFin,
        estado: estado ?? this.estado,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      );

  factory RutinaSesionDb.fromJson(Map<String, dynamic> json) => RutinaSesionDb(
        id: json["id"],
        rutinaId: json["rutina_id"],
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
        estado: json["estado"],
        fechaCreacion: json["fecha_creacion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rutina_id": rutinaId,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "estado": estado,
        "fecha_creacion": fechaCreacion,
      };
}
