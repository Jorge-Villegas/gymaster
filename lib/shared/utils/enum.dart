// ignore_for_file: constant_identifier_names

enum EstadoEjercicio { pendiente, en_progreso, completado, cancelado }

enum EstadoSesionRutina { pendiente, en_progreso, completado, cancelado }

enum EstadoEjercicioSesion { pendiente, en_progreso, completado, cancelado }

enum EstadoSerieEjercicio { pendiente, completado, fallida, cancelado }

enum AccionRegistroAuditoria { insert, update, delete }

extension EnumToString on Enum {
  String get name => toString().split('.').last;
}
