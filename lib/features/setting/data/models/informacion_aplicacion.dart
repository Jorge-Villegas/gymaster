import 'package:equatable/equatable.dart';

class InformacionAplicacion extends Equatable {
  final String? id;
  final String versionApp;
  final DateTime fechaInstalacion;
  final DateTime? fechaUltimaActualizacion;
  final int numeroIniciosSesion;
  final DateTime? fechaUltimoInicio;
  final int rachaActual;
  final int rachaMaxima;
  final int totalRutinasCompletadas;
  final int totalEjerciciosRealizados;
  final int tiempoTotalEntrenamiento; // En segundos
  final DateTime fechaCreacion;

  const InformacionAplicacion({
    this.id,
    required this.versionApp,
    required this.fechaInstalacion,
    this.fechaUltimaActualizacion,
    this.numeroIniciosSesion = 0,
    this.fechaUltimoInicio,
    this.rachaActual = 0,
    this.rachaMaxima = 0,
    this.totalRutinasCompletadas = 0,
    this.totalEjerciciosRealizados = 0,
    this.tiempoTotalEntrenamiento = 0,
    required this.fechaCreacion,
  });

  InformacionAplicacion copyWith({
    String? id,
    String? versionApp,
    DateTime? fechaInstalacion,
    DateTime? fechaUltimaActualizacion,
    int? numeroIniciosSesion,
    DateTime? fechaUltimoInicio,
    int? rachaActual,
    int? rachaMaxima,
    int? totalRutinasCompletadas,
    int? totalEjerciciosRealizados,
    int? tiempoTotalEntrenamiento,
    DateTime? fechaCreacion,
  }) =>
      InformacionAplicacion(
        id: id ?? this.id,
        versionApp: versionApp ?? this.versionApp,
        fechaInstalacion: fechaInstalacion ?? this.fechaInstalacion,
        fechaUltimaActualizacion: fechaUltimaActualizacion ?? this.fechaUltimaActualizacion,
        numeroIniciosSesion: numeroIniciosSesion ?? this.numeroIniciosSesion,
        fechaUltimoInicio: fechaUltimoInicio ?? this.fechaUltimoInicio,
        rachaActual: rachaActual ?? this.rachaActual,
        rachaMaxima: rachaMaxima ?? this.rachaMaxima,
        totalRutinasCompletadas: totalRutinasCompletadas ?? this.totalRutinasCompletadas,
        totalEjerciciosRealizados: totalEjerciciosRealizados ?? this.totalEjerciciosRealizados,
        tiempoTotalEntrenamiento: tiempoTotalEntrenamiento ?? this.tiempoTotalEntrenamiento,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      );

  @override
  List<Object?> get props => [
        id,
        versionApp,
        fechaInstalacion,
        fechaUltimaActualizacion,
        numeroIniciosSesion,
        fechaUltimoInicio,
        rachaActual,
        rachaMaxima,
        totalRutinasCompletadas,
        totalEjerciciosRealizados,
        tiempoTotalEntrenamiento,
        fechaCreacion,
      ];

  /// Formatea el tiempo total de entrenamiento en formato legible
  String get tiempoTotalFormateado {
    final horas = tiempoTotalEntrenamiento ~/ 3600;
    final minutos = (tiempoTotalEntrenamiento % 3600) ~/ 60;

    if (horas > 0) {
      return '${horas}h ${minutos}min';
    } else if (minutos > 0) {
      return '${minutos}min';
    } else {
      return 'Menos de 1min';
    }
  }

  /// Calcula el tiempo promedio por rutina en minutos
  double get tiempoPromedioRutina {
    if (totalRutinasCompletadas == 0) return 0.0;
    return (tiempoTotalEntrenamiento / 60) / totalRutinasCompletadas;
  }

  /// Formatea el tiempo promedio por rutina
  String get tiempoPromedioRutinaFormateado {
    final promedioMinutos = tiempoPromedioRutina;
    if (promedioMinutos < 1) return 'Menos de 1min';
    return '${promedioMinutos.round()}min';
  }

  /// Calcula el promedio de ejercicios por rutina
  double get promedioEjerciciosPorRutina {
    if (totalRutinasCompletadas == 0) return 0.0;
    return totalEjerciciosRealizados / totalRutinasCompletadas;
  }

  /// Días desde la instalación
  int get diasDesdeInstalacion {
    return DateTime.now().difference(fechaInstalacion).inDays;
  }

  /// Días desde el último inicio de sesión
  int? get diasDesdeUltimoInicio {
    if (fechaUltimoInicio == null) return null;
    return DateTime.now().difference(fechaUltimoInicio!).inDays;
  }

  /// Indica si el usuario es activo (ha iniciado sesión en los últimos 7 días)
  bool get esUsuarioActivo {
    final diasSinActividad = diasDesdeUltimoInicio;
    return diasSinActividad != null && diasSinActividad <= 7;
  }

  /// Nivel de usuario basado en rutinas completadas
  String get nivelUsuario {
    if (totalRutinasCompletadas < 10) return 'Novato';
    if (totalRutinasCompletadas < 50) return 'Principiante';
    if (totalRutinasCompletadas < 100) return 'Intermedio';
    if (totalRutinasCompletadas < 250) return 'Avanzado';
    if (totalRutinasCompletadas < 500) return 'Experto';
    return 'Maestro';
  }

  /// Progreso hacia el siguiente nivel (0.0 - 1.0)
  double get progresoNivel {
    final niveles = [0, 10, 50, 100, 250, 500];
    
    for (int i = 0; i < niveles.length - 1; i++) {
      if (totalRutinasCompletadas >= niveles[i] && totalRutinasCompletadas < niveles[i + 1]) {
        final progreso = (totalRutinasCompletadas - niveles[i]) / (niveles[i + 1] - niveles[i]);
        return progreso.clamp(0.0, 1.0);
      }
    }
    
    return 1.0; // Máximo nivel alcanzado
  }

  /// Rutinas necesarias para el siguiente nivel
  int get rutinasParaSiguienteNivel {
    final niveles = [10, 50, 100, 250, 500];
    
    for (final nivel in niveles) {
      if (totalRutinasCompletadas < nivel) {
        return nivel - totalRutinasCompletadas;
      }
    }
    
    return 0; // Ya está en el máximo nivel
  }

  /// Mensaje motivacional basado en las estadísticas
  String get mensajeMotivacional {
    if (totalRutinasCompletadas == 0) {
      return '¡Comienza tu primera rutina hoy!';
    }
    
    if (rachaActual >= 7) {
      return '🔥 ¡Increíble racha de $rachaActual días!';
    }
    
    if (rachaActual >= 3) {
      return '💪 ¡Mantén el momentum con $rachaActual días seguidos!';
    }
    
    if (totalRutinasCompletadas >= 100) {
      return '🏆 ¡Eres un verdadero atleta con $totalRutinasCompletadas rutinas!';
    }
    
    if (totalRutinasCompletadas >= 50) {
      return '⚡ ¡Vas por buen camino con $totalRutinasCompletadas rutinas completadas!';
    }
    
    return '🎯 Sigue adelante, cada rutina cuenta';
  }

  /// Información inicial para una nueva instalación
  factory InformacionAplicacion.nuevaInstalacion(String version) {
    final ahora = DateTime.now();
    return InformacionAplicacion(
      versionApp: version,
      fechaInstalacion: ahora,
      fechaCreacion: ahora,
    );
  }
}