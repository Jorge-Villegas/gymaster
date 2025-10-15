import 'package:equatable/equatable.dart';

class PerfilUsuario extends Equatable {
  final String? id;
  final String nombreUsuario;
  final String correo;
  final String? nombreCompleto;
  final String? fotoPerfil; // Nombre del archivo: 'perfil1.jpg', 'perfil2.jpg', etc.
  final DateTime? fechaNacimiento;
  final String? genero; // 'masculino', 'femenino', 'otro', 'prefiero_no_decir'
  final String? objetivoFitness; // 'perder_peso', 'ganar_musculo', 'mantenimiento', 'fuerza', 'resistencia', 'tonificar'
  final String? nivelExperiencia; // 'principiante', 'intermedio', 'avanzado'
  final int? alturaCm; // Altura en centímetros
  final double? pesoActualKg; // Peso actual en kilogramos
  final double? pesoObjetivoKg; // Peso objetivo en kilogramos
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacionPerfil;

  const PerfilUsuario({
    this.id,
    required this.nombreUsuario,
    required this.correo,
    this.nombreCompleto,
    this.fotoPerfil,
    this.fechaNacimiento,
    this.genero,
    this.objetivoFitness,
    this.nivelExperiencia,
    this.alturaCm,
    this.pesoActualKg,
    this.pesoObjetivoKg,
    required this.fechaCreacion,
    this.fechaActualizacionPerfil,
  });

  PerfilUsuario copyWith({
    String? id,
    String? nombreUsuario,
    String? correo,
    String? nombreCompleto,
    String? fotoPerfil,
    DateTime? fechaNacimiento,
    String? genero,
    String? objetivoFitness,
    String? nivelExperiencia,
    int? alturaCm,
    double? pesoActualKg,
    double? pesoObjetivoKg,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacionPerfil,
  }) =>
      PerfilUsuario(
        id: id ?? this.id,
        nombreUsuario: nombreUsuario ?? this.nombreUsuario,
        correo: correo ?? this.correo,
        nombreCompleto: nombreCompleto ?? this.nombreCompleto,
        fotoPerfil: fotoPerfil ?? this.fotoPerfil,
        fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
        genero: genero ?? this.genero,
        objetivoFitness: objetivoFitness ?? this.objetivoFitness,
        nivelExperiencia: nivelExperiencia ?? this.nivelExperiencia,
        alturaCm: alturaCm ?? this.alturaCm,
        pesoActualKg: pesoActualKg ?? this.pesoActualKg,
        pesoObjetivoKg: pesoObjetivoKg ?? this.pesoObjetivoKg,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacionPerfil: fechaActualizacionPerfil ?? this.fechaActualizacionPerfil,
      );

  @override
  List<Object?> get props => [
        id,
        nombreUsuario,
        correo,
        nombreCompleto,
        fotoPerfil,
        fechaNacimiento,
        genero,
        objetivoFitness,
        nivelExperiencia,
        alturaCm,
        pesoActualKg,
        pesoObjetivoKg,
        fechaCreacion,
        fechaActualizacionPerfil,
      ];

  /// Obtiene la ruta completa del avatar
  String get rutaAvatar {
    if (fotoPerfil != null && fotoPerfil!.isNotEmpty) {
      return 'assets/imagenes/perfil_avatar/$fotoPerfil';
    }
    return 'assets/imagenes/perfil_avatar/perfil1.jpg'; // Avatar por defecto
  }

  /// Indica si el perfil está completo
  bool get esPerfilCompleto {
    return nombreCompleto != null &&
        nombreCompleto!.isNotEmpty &&
        fechaNacimiento != null &&
        genero != null &&
        objetivoFitness != null &&
        nivelExperiencia != null;
  }

  /// Calcula la edad basada en la fecha de nacimiento
  int? get edad {
    if (fechaNacimiento == null) return null;
    
    final hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento!.year;
    
    if (hoy.month < fechaNacimiento!.month ||
        (hoy.month == fechaNacimiento!.month && hoy.day < fechaNacimiento!.day)) {
      edad--;
    }
    
    return edad;
  }

  /// Calcula el IMC (Índice de Masa Corporal)
  double? get imc {
    if (alturaCm == null || pesoActualKg == null) return null;
    
    final alturaEnMetros = alturaCm! / 100.0;
    return pesoActualKg! / (alturaEnMetros * alturaEnMetros);
  }

  /// Obtiene la categoría del IMC
  String get categoriaImc {
    final imcValue = imc;
    if (imcValue == null) return 'No disponible';
    
    if (imcValue < 18.5) return 'Bajo peso';
    if (imcValue < 25.0) return 'Peso normal';
    if (imcValue < 30.0) return 'Sobrepeso';
    return 'Obesidad';
  }

  /// Lista de avatares disponibles
  static List<String> get avataresDisponibles {
    return List.generate(12, (index) => 'perfil${index + 1}.jpg');
  }

  /// Lista de géneros válidos
  static List<String> get generosValidos {
    return ['masculino', 'femenino', 'otro', 'prefiero_no_decir'];
  }

  /// Lista de objetivos fitness válidos
  static List<String> get objetivosValidosMap {
    return ['perder_peso', 'ganar_musculo', 'mantenimiento', 'fuerza', 'resistencia', 'tonificar'];
  }

  /// Lista de niveles de experiencia válidos
  static List<String> get nivelesExperienciaValidos {
    return ['principiante', 'intermedio', 'avanzado'];
  }

  /// Obtiene el nombre amigable del objetivo fitness
  String get objetivoFitnessAmigable {
    const mapaObjetivos = {
      'perder_peso': 'Perder peso',
      'ganar_musculo': 'Ganar músculo',
      'mantenimiento': 'Mantenimiento',
      'fuerza': 'Ganar fuerza',
      'resistencia': 'Mejorar resistencia',
      'tonificar': 'Tonificar cuerpo',
    };
    return mapaObjetivos[objetivoFitness] ?? objetivoFitness ?? '';
  }

  /// Obtiene el nombre amigable del nivel de experiencia
  String get nivelExperienciaAmigable {
    const mapaNiveles = {
      'principiante': 'Principiante',
      'intermedio': 'Intermedio',
      'avanzado': 'Avanzado',
    };
    return mapaNiveles[nivelExperiencia] ?? nivelExperiencia ?? '';
  }

  /// Obtiene el nombre amigable del género
  String get generoAmigable {
    const mapaGeneros = {
      'masculino': 'Masculino',
      'femenino': 'Femenino',
      'otro': 'Otro',
      'prefiero_no_decir': 'Prefiero no decir',
    };
    return mapaGeneros[genero] ?? genero ?? '';
  }

  /// Validación de datos del perfil
  bool get esPerfilValido {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    
    return nombreUsuario.isNotEmpty &&
        correo.isNotEmpty &&
        emailRegex.hasMatch(correo) &&
        (alturaCm == null || (alturaCm! >= 100 && alturaCm! <= 250)) &&
        (pesoActualKg == null || (pesoActualKg! >= 30 && pesoActualKg! <= 300)) &&
        (pesoObjetivoKg == null || (pesoObjetivoKg! >= 30 && pesoObjetivoKg! <= 300)) &&
        (genero == null || generosValidos.contains(genero)) &&
        (objetivoFitness == null || objetivosValidosMap.contains(objetivoFitness)) &&
        (nivelExperiencia == null || nivelesExperienciaValidos.contains(nivelExperiencia));
  }
}