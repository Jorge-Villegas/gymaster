import 'package:equatable/equatable.dart';

enum Genero { masculino, femenino, otro, prefiero_no_decir }

enum ObjetivoFitness {
  perder_peso,
  ganar_musculo,
  mantenimiento,
  fuerza,
  resistencia,
  tonificar
}

enum NivelExperiencia { principiante, intermedio, avanzado }

class PerfilUsuarioCompleto extends Equatable {
  final String? id;
  final String nombreUsuario;
  final String? correo;
  final String fotoPerfil; // Avatar seleccionado
  final String nombreCompleto;
  final DateTime? fechaNacimiento;
  final Genero genero;
  final ObjetivoFitness objetivoFitness;
  final NivelExperiencia nivelExperiencia;
  final int? alturaCm;
  final double? pesoActualKg;
  final double? pesoObjetivoKg;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;

  const PerfilUsuarioCompleto({
    this.id,
    required this.nombreUsuario,
    this.correo,
    required this.fotoPerfil,
    required this.nombreCompleto,
    this.fechaNacimiento,
    required this.genero,
    required this.objetivoFitness,
    required this.nivelExperiencia,
    this.alturaCm,
    this.pesoActualKg,
    this.pesoObjetivoKg,
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  PerfilUsuarioCompleto copyWith({
    String? id,
    String? nombreUsuario,
    String? correo,
    String? fotoPerfil,
    String? nombreCompleto,
    DateTime? fechaNacimiento,
    Genero? genero,
    ObjetivoFitness? objetivoFitness,
    NivelExperiencia? nivelExperiencia,
    int? alturaCm,
    double? pesoActualKg,
    double? pesoObjetivoKg,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) =>
      PerfilUsuarioCompleto(
        id: id ?? this.id,
        nombreUsuario: nombreUsuario ?? this.nombreUsuario,
        correo: correo ?? this.correo,
        fotoPerfil: fotoPerfil ?? this.fotoPerfil,
        nombreCompleto: nombreCompleto ?? this.nombreCompleto,
        fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
        genero: genero ?? this.genero,
        objetivoFitness: objetivoFitness ?? this.objetivoFitness,
        nivelExperiencia: nivelExperiencia ?? this.nivelExperiencia,
        alturaCm: alturaCm ?? this.alturaCm,
        pesoActualKg: pesoActualKg ?? this.pesoActualKg,
        pesoObjetivoKg: pesoObjetivoKg ?? this.pesoObjetivoKg,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );

  // Verificar si el perfil está completo
  bool get estaCompleto {
    return nombreCompleto.isNotEmpty &&
        fotoPerfil.isNotEmpty &&
        fechaNacimiento != null &&
        (alturaCm != null && alturaCm! > 0) &&
        (pesoActualKg != null && pesoActualKg! > 0);
  }

  // Calcular edad
  int? get edad {
    if (fechaNacimiento == null) return null;
    final hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento!.year;
    if (hoy.month < fechaNacimiento!.month ||
        (hoy.month == fechaNacimiento!.month &&
            hoy.day < fechaNacimiento!.day)) {
      edad--;
    }
    return edad;
  }

  // Calcular IMC
  double? get imc {
    if (alturaCm == null || pesoActualKg == null) return null;
    final alturaM = alturaCm! / 100.0;
    return pesoActualKg! / (alturaM * alturaM);
  }

  @override
  List<Object?> get props => [
        id,
        nombreUsuario,
        correo,
        fotoPerfil,
        nombreCompleto,
        fechaNacimiento,
        genero,
        objetivoFitness,
        nivelExperiencia,
        alturaCm,
        pesoActualKg,
        pesoObjetivoKg,
        fechaCreacion,
        fechaActualizacion,
      ];
}

// Extensiones para convertir enums
extension GeneroExtension on Genero {
  String get nombre {
    switch (this) {
      case Genero.masculino:
        return 'Masculino';
      case Genero.femenino:
        return 'Femenino';
      case Genero.otro:
        return 'Otro';
      case Genero.prefiero_no_decir:
        return 'Prefiero no decir';
    }
  }

  String get valor {
    return toString().split('.').last;
  }

  static Genero fromString(String valor) {
    return Genero.values.firstWhere(
      (e) => e.valor == valor,
      orElse: () => Genero.prefiero_no_decir,
    );
  }
}

extension ObjetivoFitnessExtension on ObjetivoFitness {
  String get nombre {
    switch (this) {
      case ObjetivoFitness.perder_peso:
        return 'Perder peso';
      case ObjetivoFitness.ganar_musculo:
        return 'Ganar músculo';
      case ObjetivoFitness.mantenimiento:
        return 'Mantener peso';
      case ObjetivoFitness.fuerza:
        return 'Ganar fuerza';
      case ObjetivoFitness.resistencia:
        return 'Mejorar resistencia';
      case ObjetivoFitness.tonificar:
        return 'Tonificar cuerpo';
    }
  }

  String get emoji {
    switch (this) {
      case ObjetivoFitness.perder_peso:
        return '⚖️';
      case ObjetivoFitness.ganar_musculo:
        return '💪';
      case ObjetivoFitness.mantenimiento:
        return '⚖️';
      case ObjetivoFitness.fuerza:
        return '🏋️';
      case ObjetivoFitness.resistencia:
        return '🏃';
      case ObjetivoFitness.tonificar:
        return '✨';
    }
  }

  String get valor {
    return toString().split('.').last;
  }

  static ObjetivoFitness fromString(String valor) {
    return ObjetivoFitness.values.firstWhere(
      (e) => e.valor == valor,
      orElse: () => ObjetivoFitness.mantenimiento,
    );
  }
}

extension NivelExperienciaExtension on NivelExperiencia {
  String get nombre {
    switch (this) {
      case NivelExperiencia.principiante:
        return 'Principiante';
      case NivelExperiencia.intermedio:
        return 'Intermedio';
      case NivelExperiencia.avanzado:
        return 'Avanzado';
    }
  }

  String get descripcion {
    switch (this) {
      case NivelExperiencia.principiante:
        return 'Menos de 6 meses entrenando';
      case NivelExperiencia.intermedio:
        return '6 meses a 2 años entrenando';
      case NivelExperiencia.avanzado:
        return 'Más de 2 años entrenando';
    }
  }

  String get valor {
    return toString().split('.').last;
  }

  static NivelExperiencia fromString(String valor) {
    return NivelExperiencia.values.firstWhere(
      (e) => e.valor == valor,
      orElse: () => NivelExperiencia.principiante,
    );
  }
}
