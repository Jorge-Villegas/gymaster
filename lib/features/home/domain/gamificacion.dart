import 'package:gymaster/features/record/domain/entities/record_rutina.dart';

/// Un día de la semana en curso, con su estado de entrenamiento.
class DiaSemana {
  final String etiqueta; // 'L', 'M', 'M', 'J', 'V', 'S', 'D'
  final bool hecho;
  final bool esHoy;
  const DiaSemana(this.etiqueta, this.hecho, this.esHoy);
}

/// Estadísticas de gamificación derivadas de los entrenamientos reales
/// (historial de rutinas completadas). Lógica pura y testeable.
///
/// Reglas simples y transparentes:
/// - XP: 100 por rutina completada.
/// - Nivel: uno cada 1000 XP.
/// - Racha: días consecutivos con al menos un entreno, terminando hoy
///   (o ayer, para no "romperla" si aún no entrenas hoy).
class Gamificacion {
  final int entrenos;
  final int racha;
  final int xp;
  final int nivel;
  final String nivelNombre;
  final int xpEnNivel;
  final int xpPorNivel;
  final int logros;
  final int logrosTotal;
  final List<DiaSemana> semana;

  const Gamificacion({
    required this.entrenos,
    required this.racha,
    required this.xp,
    required this.nivel,
    required this.nivelNombre,
    required this.xpEnNivel,
    required this.xpPorNivel,
    required this.logros,
    required this.logrosTotal,
    required this.semana,
  });

  double get progresoNivel => xpPorNivel == 0 ? 0 : xpEnNivel / xpPorNivel;
  int get xpParaSiguiente => xpPorNivel - xpEnNivel;

  static const int _xpPorEntreno = 100;
  static const int _xpPorNivel = 1000;
  static const List<int> _hitosLogros = [1, 3, 7, 15, 30, 50, 75, 100];
  static const List<String> _nombresNivel = [
    'Rata Novata',
    'Rata Constante',
    'Rata Fuerte',
    'Rata de Acero',
    'Rata de Hierro',
    'Rata Élite',
    'Rata Leyenda',
  ];

  factory Gamificacion.desde(List<RecordRutina> rutinas, {DateTime? ahora}) {
    final hoy = _soloDia(ahora ?? DateTime.now());
    final diasConEntreno = rutinas.map((r) => _soloDia(r.fechaRealizada)).toSet();

    // Racha: cuenta hacia atrás desde hoy (o ayer si hoy aún no hay entreno).
    var racha = 0;
    var cursor = hoy;
    if (!diasConEntreno.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while (diasConEntreno.contains(cursor)) {
      racha++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    final entrenos = rutinas.length;
    final xp = entrenos * _xpPorEntreno;
    final nivel = (xp ~/ _xpPorNivel) + 1;
    final xpEnNivel = xp % _xpPorNivel;
    final nombre = _nombresNivel[
        (nivel - 1).clamp(0, _nombresNivel.length - 1)];

    final logros = _hitosLogros.where((h) => entrenos >= h).length;

    // Semana en curso (lunes a domingo).
    final lunes = hoy.subtract(Duration(days: hoy.weekday - 1));
    const etiquetas = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final semana = List<DiaSemana>.generate(7, (i) {
      final dia = lunes.add(Duration(days: i));
      return DiaSemana(
        etiquetas[i],
        diasConEntreno.contains(dia),
        dia == hoy,
      );
    });

    return Gamificacion(
      entrenos: entrenos,
      racha: racha,
      xp: xp,
      nivel: nivel,
      nivelNombre: nombre,
      xpEnNivel: xpEnNivel,
      xpPorNivel: _xpPorNivel,
      logros: logros,
      logrosTotal: _hitosLogros.length,
      semana: semana,
    );
  }

  static DateTime _soloDia(DateTime d) => DateTime(d.year, d.month, d.day);
}
