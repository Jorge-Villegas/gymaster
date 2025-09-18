import '../../domain/entities/logro.dart';
import '../../domain/repositories/achievement_repository.dart';

abstract class LogroLocalDataSource {
  Future<List<Logro>> obtenerTodosLosLogros();
  Future<List<Logro>> obtenerLogrosPorTipo(TipoLogro type);
  Future<List<Logro>> obtenerLogrosDesbloqueados();
  Future<List<Logro>> obtenerLogrosPorRareza(RarezaLogro rarity);
  Future<Logro> insertarLogro(Logro logro);
  Future<Logro> actualizarLogro(Logro logro);
  Future<Logro> desbloquearLogro(String logroId);
  Future<Logro> actualizarProgresoLogro({
    required String logroId,
    required double progreso,
  });
  Future<Logro?> obtenerLogroPorId(String id);
  Future<int> obtenerTotalPuntosLogros();
  Future<AchievementStats> obtenerEstadisticasLogros();
  Future<bool> existenLogrosInicializados();
  Future<void> inicializarLogrosPredefinidos(List<Logro> achievements);
  Future<void> eliminarTodosLosLogros();
}
