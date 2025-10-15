/// Configuración unificada para el sistema de onboarding
class OnboardingConfig {
  static const List<OnboardingPageConfig> pages = [
    // Página 1: Avatar
    OnboardingPageConfig(
      id: 'avatar',
      titulo: 'Elige tu Avatar',
      subtitulo: '¡Personaliza tu experiencia!',
      numeroPaso: 1,
      nombreRuta: 'onboarding_avatar',
      textoMotivacional: '¡Perfecto! Vamos a personalizar tu experiencia',
    ),

    // Página 2: Datos Personales
    OnboardingPageConfig(
      id: 'datos_personales',
      titulo: 'Datos Personales',
      subtitulo: 'Cuéntanos un poco sobre ti',
      numeroPaso: 2,
      nombreRuta: 'onboarding_datos_personales',
      textoMotivacional: '¡Excelente! Ahora conocemos más sobre ti',
    ),

    // Página 3: Objetivos
    OnboardingPageConfig(
      id: 'objetivos',
      titulo: 'Objetivos',
      subtitulo: '¿Qué quieres lograr?',
      numeroPaso: 3,
      nombreRuta: 'onboarding_objetivos',
      textoMotivacional: '¡Genial! Ya tenemos tu objetivo claro',
    ),

    // Página 4: Nivel Experiencia
    OnboardingPageConfig(
      id: 'nivel_experiencia',
      titulo: 'Nivel de Experiencia',
      subtitulo: '¿Cuánta experiencia tienes?',
      numeroPaso: 4,
      nombreRuta: 'onboarding_nivel_experiencia',
      textoMotivacional: '¡Perfecto! Ya sabemos tu nivel',
    ),

    // Página 5: Motivaciones
    OnboardingPageConfig(
      id: 'motivaciones',
      titulo: 'Motivaciones',
      subtitulo: '¿Qué te motiva a entrenar?',
      numeroPaso: 5,
      nombreRuta: 'onboarding_motivaciones',
      textoMotivacional: '¡Vamos a conocerte! 🎯',
    ),

    // Página 6: Desafíos
    OnboardingPageConfig(
      id: 'desafios',
      titulo: 'Desafíos',
      subtitulo: '¿Qué te resulta más difícil?',
      numeroPaso: 6,
      nombreRuta: 'onboarding_desafios',
      textoMotivacional: '¡Genial, sigamos! 💪',
    ),

    // Página 7: Sentimientos Post-Entrenamiento
    OnboardingPageConfig(
      id: 'sentimientos_post_entrenamiento',
      titulo: 'Sentimientos Post-Entrenamiento',
      subtitulo: '¿Cómo te sientes después?',
      numeroPaso: 7,
      nombreRuta: 'onboarding_sentimientos',
      textoMotivacional: '¡Casi terminamos! 🌟',
    ),

    // Página 8: Notificaciones
    OnboardingPageConfig(
      id: 'notificaciones',
      titulo: 'Notificaciones',
      subtitulo: 'Personaliza tus recordatorios',
      numeroPaso: 8,
      nombreRuta: 'onboarding_notificaciones',
      textoMotivacional: '¡Último paso! 🚀',
    ),
  ];

  /// Obtiene el número total de páginas
  static int get totalPaginas => pages.length;

  /// Obtiene el número total de pasos (igual al número de páginas)
  static int get totalPasos => pages.length;

  /// Obtiene la configuración de una página por ID
  static OnboardingPageConfig? getPageById(String id) {
    try {
      return pages.firstWhere((page) => page.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene la configuración de una página por número de paso
  static OnboardingPageConfig? getPageByStepNumber(int stepNumber) {
    try {
      return pages.firstWhere((page) => page.numeroPaso == stepNumber);
    } catch (e) {
      return null;
    }
  }

  /// Calcula el progreso global basado en la página actual
  static double calcularProgresoGlobal(int paginaActual) {
    return (paginaActual + 1) / totalPasos;
  }

  /// Obtiene el número global de paso actual
  static int obtenerNumeroPasoGlobal(int paginaActual) {
    return paginaActual + 1;
  }
}

/// Configuración de una página de onboarding
class OnboardingPageConfig {
  final String id;
  final String titulo;
  final String subtitulo;
  final int numeroPaso;
  final String nombreRuta;
  final String textoMotivacional;

  const OnboardingPageConfig({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.numeroPaso,
    required this.nombreRuta,
    required this.textoMotivacional,
  });
}
