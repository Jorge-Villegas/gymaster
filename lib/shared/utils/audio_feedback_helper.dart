import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Sistema de feedback audio emocional para GyMaster
/// Proporciona retroalimentación auditiva que refuerza emociones positivas
///
/// NOTA: Para implementación completa se requiere:
/// 1. Añadir assets de audio en pubspec.yaml
/// 2. Instalar package 'audioplayers' o 'just_audio'
/// 3. Añadir archivos de sonido en assets/sounds/
///
/// Por ahora implementa feedback básico del sistema
class AudioFeedbackHelper {
  static final AudioFeedbackHelper _instance = AudioFeedbackHelper._internal();
  factory AudioFeedbackHelper() => _instance;
  AudioFeedbackHelper._internal();

  /// Configuración de audio habilitado/deshabilitado
  static bool _isAudioEnabled = true;

  /// Getter y setter para controlar audio globalmente
  static bool get isAudioEnabled => _isAudioEnabled;
  static set isAudioEnabled(bool enabled) {
    _isAudioEnabled = enabled;
  }

  /// Sonido de éxito al completar ejercicio
  /// TODO: Implementar con 'assets/sounds/success_applause.mp3'
  static Future<void> reproducirSonidoExito() async {
    if (!_isAudioEnabled) return;

    try {
      // Por ahora usa sonido del sistema
      await SystemSound.play(SystemSoundType.alert);
      debugPrint('🎵 FeedbackAudio: Sonido de éxito reproducido');

      // TODO: Implementar cuando se añadan assets
      // await _audioPlayer.play(AssetSource('sounds/success_applause.mp3'));
    } catch (e) {
      debugPrint('❌ Error FeedbackAudio: $e');
    }
  }

  /// Sonido de celebración al completar rutina
  /// TODO: Implementar con 'assets/sounds/celebration_fanfare.mp3'
  static Future<void> reproducirSonidoCelebracion() async {
    if (!_isAudioEnabled) return;

    try {
      // Sonido más largo para celebración épica
      await SystemSound.play(SystemSoundType.alert);
      await Future.delayed(const Duration(milliseconds: 500));
      await SystemSound.play(SystemSoundType.alert);
      debugPrint('🎉 FeedbackAudio: Sonido de celebración reproducido');

      // TODO: Implementar cuando se añadan assets
      // await _audioPlayer.play(AssetSource('sounds/celebration_fanfare.mp3'));
    } catch (e) {
      debugPrint('❌ Error FeedbackAudio: $e');
    }
  }

  /// Sonido motivacional al iniciar rutina
  /// TODO: Implementar con 'assets/sounds/motivation_bell.mp3'
  static Future<void> reproducirSonidoMotivacional() async {
    if (!_isAudioEnabled) return;

    try {
      await SystemSound.play(SystemSoundType.click);
      debugPrint('💪 FeedbackAudio: Sonido motivacional reproducido');

      // TODO: Implementar cuando se añadan assets
      // await _audioPlayer.play(AssetSource('sounds/motivation_bell.mp3'));
    } catch (e) {
      debugPrint('❌ AudioFeedback Error: $e');
    }
  }

  /// Sonido de progreso (al completar serie)
  /// TODO: Implementar con 'assets/sounds/progress_ding.mp3'
  static Future<void> playProgressSound() async {
    if (!_isAudioEnabled) return;

    try {
      await SystemSound.play(SystemSoundType.click);
      debugPrint('📊 FeedbackAudio: Sonido de progreso reproducido');

      // TODO: Implementar cuando se añadan assets
      // await _audioPlayer.play(AssetSource('sounds/progress_ding.mp3'));
    } catch (e) {
      debugPrint('❌ AudioFeedback Error: $e');
    }
  }

  /// Sonido de alerta suave para recordatorios
  /// TODO: Implementar con 'assets/sounds/gentle_chime.mp3'
  static Future<void> reproducirSonidoRecordatorio() async {
    if (!_isAudioEnabled) return;

    try {
      await SystemSound.play(SystemSoundType.click);
      debugPrint('⏰ FeedbackAudio: Sonido de recordatorio reproducido');

      // TODO: Implementar cuando se añadan assets
      // await _audioPlayer.play(AssetSource('sounds/gentle_chime.mp3'));
    } catch (e) {
      debugPrint('❌ AudioFeedback Error: $e');
    }
  }

  /// Feedback audio combinado con háptico
  static Future<void> reproducirFeedbackExitoCombinado() async {
    // Importar HapticFeedbackHelper cuando esté disponible
    // await HapticFeedbackHelper.successVibration();
    await reproducirSonidoExito();
  }

  static Future<void> reproducirFeedbackCelebracionCombinado() async {
    // await HapticFeedbackHelper.achievementVibration();
    await reproducirSonidoCelebracion();
  }

  static Future<void> reproducirFeedbackMotivacionalCombinado() async {
    // await HapticFeedbackHelper.encouragementVibration();
    await reproducirSonidoMotivacional();
  }
}

/// Enumeración de tipos de audio feedback
enum AudioType {
  exito,
  celebracion,
  motivacion,
  progreso,
  recordatorio,
}

/// Extensión para facilitar el uso en widgets
extension AudioFeedbackExtension on AudioType {
  Future<void> play() async {
    switch (this) {
      case AudioType.exito:
        await AudioFeedbackHelper.reproducirSonidoExito();
        break;
      case AudioType.celebracion:
        await AudioFeedbackHelper.reproducirSonidoCelebracion();
        break;
      case AudioType.motivacion:
        await AudioFeedbackHelper.reproducirSonidoMotivacional();
        break;
      case AudioType.progreso:
        await AudioFeedbackHelper.playProgressSound();
        break;
      case AudioType.recordatorio:
        await AudioFeedbackHelper.reproducirSonidoRecordatorio();
        break;
    }
  }

  Future<void> reproducirConFeedbackHaptico() async {
    switch (this) {
      case AudioType.exito:
        await AudioFeedbackHelper.reproducirFeedbackExitoCombinado();
        break;
      case AudioType.celebracion:
        await AudioFeedbackHelper.reproducirFeedbackCelebracionCombinado();
        break;
      case AudioType.motivacion:
        await AudioFeedbackHelper.reproducirFeedbackMotivacionalCombinado();
        break;
      case AudioType.progreso:
        await AudioFeedbackHelper.playProgressSound();
        break;
      case AudioType.recordatorio:
        await AudioFeedbackHelper.reproducirSonidoRecordatorio();
        break;
    }
  }
}

/// Widget helper para facilitar el uso de audio feedback
class AudioFeedbackWidget extends StatelessWidget {
  final Widget child;
  final AudioType? audioType;
  final VoidCallback? onTap;
  final bool enableHaptic;

  const AudioFeedbackWidget({
    super.key,
    required this.child,
    this.audioType,
    this.onTap,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (audioType != null) {
          if (enableHaptic) {
            await audioType!.reproducirConFeedbackHaptico();
          } else {
            await audioType!.play();
          }
        }
        onTap?.call();
      },
      child: child,
    );
  }
}

/// Instrucciones para implementación completa:
///
/// 1. Añadir al pubspec.yaml:
/// ```yaml
/// dependencies:
///   audioplayers: ^5.0.0  # o just_audio: ^0.9.34
///
/// flutter:
///   assets:
///     - assets/sounds/
/// ```
///
/// 2. Crear directorio assets/sounds/ con archivos:
///    - success_applause.mp3 (1-2 segundos, aplausos suaves)
///    - celebration_fanfare.mp3 (3-4 segundos, trompetas épicas)
///    - motivation_bell.mp3 (1 segundo, campana energética)
///    - progress_ding.mp3 (0.5 segundos, ding satisfactorio)
///    - gentle_chime.mp3 (1 segundo, chime suave)
///
/// 3. Reemplazar SystemSound.play() con:
/// ```dart
/// final AudioPlayer _audioPlayer = AudioPlayer();
/// await _audioPlayer.play(AssetSource('sounds/archivo.mp3'));
/// ```
