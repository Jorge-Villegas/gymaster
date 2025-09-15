import 'dart:math';

/// Servicio para generar mensajes emocionales personalizados en GyMaster
/// Proporciona contexto emocional basado en progreso del usuario y tipo de logro
class MensajesEmocionalesService {
  static final Random _random = Random();

  static String obtenerMensajeDeCompletacion(
    String nombreRutina,
    int totalRutinasCompletadas,
    int totalEjercicios,
    int totalSeries,
  ) {
    if (totalRutinasCompletadas == 1) {
      return _obtenerMensajePrimerRutinaCompletada();
    } else if (totalRutinasCompletadas <= 5) {
      return _obtenerMensajePrincipiante(totalRutinasCompletadas);
    } else if (totalRutinasCompletadas <= 15) {
      return _obtenerMensajeIntermedio(totalRutinasCompletadas);
    } else if (totalRutinasCompletadas <= 50) {
      return _obtenerMensajeAvanzado(totalRutinasCompletadas);
    } else {
      return _obtenerMensajeExperto(totalRutinasCompletadas);
    }
  }

  static String obtenerSubtituloContextual(
    String nombreRutina,
    int totalRutinasCompletadas,
    int totalEjercicios,
  ) {
    final List<String> mensajesMotivacionales = [
      'Tu dedicación está construyendo un hábito sólido 💪',
      'Cada rutina te acerca más a tus objetivos 🎯',
      'Tu consistencia es inspiradora 🌟',
      'Estás transformando tu vida paso a paso 🚀',
      'Tu progreso habla por sí mismo 📈',
    ];

    if (totalRutinasCompletadas >= 10) {
      return '¡Esta es tu rutina #$totalRutinasCompletadas! ${mensajesMotivacionales[_random.nextInt(mensajesMotivacionales.length)]}';
    } else {
      return 'Has completado "$nombreRutina" con $totalEjercicios ejercicios';
    }
  }

  static String obtenerEstadisticasContext(int totalRutinasCompletadas) {
    if (totalRutinasCompletadas >= 30) {
      return '🏆 Estás en el top 5% de usuarios más consistentes';
    } else if (totalRutinasCompletadas >= 15) {
      return '🔥 Tu constancia está por encima del promedio';
    } else if (totalRutinasCompletadas >= 7) {
      return '⭐ Estás desarrollando un hábito sólido';
    } else if (totalRutinasCompletadas >= 3) {
      return '💫 Vas por buen camino, sigue así';
    } else {
      return '🌱 Cada paso cuenta en tu journey fitness';
    }
  }

  static String obtenerProyeccionDeLogros(int totalRutinasCompletadas) {
    final int rutinasParaSiguienteHito =
        _obtenerSiguienteHito(totalRutinasCompletadas);
    final int rutinasRestantes =
        rutinasParaSiguienteHito - totalRutinasCompletadas;

    if (rutinasRestantes <= 1) {
      return '🎊 ¡Estás a punto de alcanzar un hito especial!';
    } else if (rutinasRestantes <= 3) {
      return '🎯 Solo $rutinasRestantes rutinas más para tu próximo logro';
    } else {
      return '📊 Próximo hito en $rutinasRestantes rutinas';
    }
  }

  // MÉTODOS PRIVADOS

  static String _obtenerMensajePrimerRutinaCompletada() {
    final List<String> mensajes = [
      '¡Acabas de dar el primer paso hacia una nueva versión de ti! 🌟',
      '¡Felicidades por comenzar tu transformación! 💪',
      '¡El viaje hacia tus objetivos oficialmente ha comenzado! 🚀',
      '¡Primer paso completado! Tu futuro yo te lo agradecerá 🙏',
    ];
    return mensajes[_random.nextInt(mensajes.length)];
  }

  static String _obtenerMensajePrincipiante(int rutinas) {
    final List<String> mensajes = [
      '¡Vas construyendo momentum! La consistencia es clave 🔑',
      '¡Cada rutina cuenta! Estás formando un hábito poderoso 💫',
      '¡Progreso sólido! Tu disciplina está dando frutos 🌱',
      '¡Excelente trabajo! Los hábitos se forman con persistencia 🎯',
    ];
    return mensajes[_random.nextInt(mensajes.length)];
  }

  static String _obtenerMensajeIntermedio(int rutinas) {
    final List<String> mensajes = [
      '¡Tu consistencia es admirable! Sigues demostrando que puedes 💪',
      '¡Estás en racha! Tu dedicación está marcando la diferencia 🔥',
      '¡Increíble progreso! Ya no eres principiante, eres un veterano 🏆',
      '¡Tu transformación es visible! Sigue así, campeón 👑',
    ];
    return mensajes[_random.nextInt(mensajes.length)];
  }

  static String _obtenerMensajeAvanzado(int rutinas) {
    final List<String> mensajes = [
      '¡Eres oficialmente un atleta dedicado! Tu ejemplo inspira 🌟',
      '¡Nivel experto alcanzado! Tu disciplina es extraordinaria 💎',
      '¡Estás en la élite! Pocos logran esta consistencia 🏅',
      '¡Imparable! Tu dedicación redefine lo que es posible 🚀',
    ];
    return mensajes[_random.nextInt(mensajes.length)];
  }

  static String _obtenerMensajeExperto(int rutinas) {
    final List<String> mensajes = [
      '¡Leyenda del fitness! Tu legado inspira a toda la comunidad 👑',
      '¡Maestro de la disciplina! Eres un ejemplo para todos 🏆',
      '¡Élite absoluta! Tu dedicación no tiene límites ∞',
      '¡Fenómeno! Redefiniste lo que significa ser consistente 🌟',
    ];
    return mensajes[_random.nextInt(mensajes.length)];
  }

  static int _obtenerSiguienteHito(int rutinasActuales) {
    final List<int> hitos = [1, 3, 5, 7, 10, 15, 20, 25, 30, 40, 50, 75, 100];

    for (final hito in hitos) {
      if (rutinasActuales < hito) {
        return hito;
      }
    }

    // Para números muy altos, siguiente múltiplo de 25
    return ((rutinasActuales ~/ 25) + 1) * 25;
  }
}

extension ProgressEmotionalIcons on int {
  String get iconoProgreso {
    if (this >= 50) return '👑'; // Rey/Reina
    if (this >= 30) return '🏆'; // Trofeo
    if (this >= 15) return '💎'; // Diamante
    if (this >= 7) return '🔥'; // Fuego
    if (this >= 3) return '⭐'; // Estrella
    return '🌱'; // Brote
  }

  String get insigniaProgreso {
    if (this >= 50) return 'LEYENDA';
    if (this >= 30) return 'EXPERTO';
    if (this >= 15) return 'AVANZADO';
    if (this >= 7) return 'INTERMEDIO';
    if (this >= 3) return 'PROGRESANDO';
    return 'INICIANDO';
  }
}
