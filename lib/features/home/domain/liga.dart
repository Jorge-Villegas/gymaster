/// =============================================================================
/// LIGA FANTASMA LOCAL 🏆 — GyMaster
/// -----------------------------------------------------------------------------
/// Ranking semanal competitivo que funciona 100% offline: el usuario compite
/// contra rivales SIMULADOS (bots) con XP realista. Aprovecha el estatus social
/// y las ganas de ganar (patrón "Leagues" de Duolingo) sin necesitar backend.
///
/// Es determinista dentro de la misma semana (los rivales no cambian de valor
/// al reabrir la app) y rota cada lunes. Cuando exista un backend, basta
/// reemplazar los bots por personas reales sin rediseñar la UI.
/// =============================================================================
library;

/// Un participante del ranking (el usuario o un rival simulado).
class LigaRival {
  final String nombre;
  final String emoji;
  final int xp;
  final bool esUsuario;

  const LigaRival({
    required this.nombre,
    required this.emoji,
    required this.xp,
    this.esUsuario = false,
  });
}

/// Nivel/tier de la liga (estética de progreso tipo Duolingo).
enum LigaTier { bronce, plata, oro, diamante }

extension LigaTierX on LigaTier {
  String get nombre => switch (this) {
        LigaTier.bronce => 'Liga Bronce',
        LigaTier.plata => 'Liga Plata',
        LigaTier.oro => 'Liga Oro',
        LigaTier.diamante => 'Liga Diamante',
      };

  String get emoji => switch (this) {
        LigaTier.bronce => '🥉',
        LigaTier.plata => '🥈',
        LigaTier.oro => '🥇',
        LigaTier.diamante => '💎',
      };
}

/// Estado completo de la liga semanal del usuario.
class Liga {
  /// Ranking ordenado de mayor a menor XP (posición 1 = índice 0).
  final List<LigaRival> ranking;

  /// Tier actual, según el XP total del usuario.
  final LigaTier tier;

  /// Cuántos rivales ascienden (zona verde, arriba).
  final int puestosAscenso;

  /// Cuántos rivales descienden (zona roja, abajo).
  final int puestosDescenso;

  const Liga({
    required this.ranking,
    required this.tier,
    this.puestosAscenso = 3,
    this.puestosDescenso = 3,
  });

  /// Posición del usuario (1-based).
  int get posicionUsuario =>
      ranking.indexWhere((r) => r.esUsuario) + 1;

  int get totalParticipantes => ranking.length;

  /// El usuario está en zona de ascenso.
  bool get enZonaAscenso => posicionUsuario <= puestosAscenso;

  /// El usuario está en zona de descenso.
  bool get enZonaDescenso =>
      posicionUsuario > totalParticipantes - puestosDescenso;

  /// XP que le falta al usuario para alcanzar al rival de arriba (0 si lidera).
  int get xpParaSubir {
    final pos = posicionUsuario;
    if (pos <= 1) return 0;
    final yo = ranking[pos - 1];
    final arriba = ranking[pos - 2];
    return (arriba.xp - yo.xp).clamp(0, 999999);
  }

  /// Genera la liga de la semana. [xpSemana] es el XP real del usuario esta
  /// semana; [xpTotal] decide el tier. Determinista por semana (misma semana →
  /// mismos rivales) gracias a una semilla derivada del número de semana ISO.
  factory Liga.generar({
    required int xpSemana,
    required int xpTotal,
    required String nombreUsuario,
    DateTime? ahora,
  }) {
    final hoy = ahora ?? DateTime.now();
    final semilla = _numeroSemanaISO(hoy) + hoy.year * 100;
    final rand = _Lcg(semilla);

    // Tier según XP total acumulado.
    final tier = xpTotal >= 8000
        ? LigaTier.diamante
        : xpTotal >= 4000
            ? LigaTier.oro
            : xpTotal >= 1500
                ? LigaTier.plata
                : LigaTier.bronce;

    // 9 rivales simulados alrededor del XP del usuario para que la competencia
    // se sienta reñida (unos por encima, otros por debajo).
    const nombres = [
      ('Valentina', '🦊'),
      ('Mateo', '🐻'),
      ('Sofía', '🐰'),
      ('Diego', '🐯'),
      ('Camila', '🦁'),
      ('Lucas', '🐺'),
      ('Martina', '🐹'),
      ('Thiago', '🦅'),
      ('Isabella', '🐨'),
    ];

    final rivales = <LigaRival>[];
    for (final (nombre, emoji) in nombres) {
      // Offset entre -300 y +400 XP respecto al usuario, en pasos de 100.
      final offset = (rand.next(8) - 3) * 100;
      final baseXp = (xpSemana + offset).clamp(0, 999999);
      // Pequeña variación fina para evitar empates exactos.
      final xp = baseXp + rand.next(90);
      rivales.add(LigaRival(nombre: nombre, emoji: emoji, xp: xp));
    }

    final yo = LigaRival(
      nombre: nombreUsuario.trim().isEmpty ? 'Tú' : nombreUsuario.trim(),
      emoji: '🐀',
      xp: xpSemana,
      esUsuario: true,
    );

    final ranking = [...rivales, yo]..sort((a, b) => b.xp.compareTo(a.xp));

    return Liga(ranking: ranking, tier: tier);
  }

  /// Número de semana ISO-8601 (1–53).
  static int _numeroSemanaISO(DateTime fecha) {
    final dia = DateTime(fecha.year, fecha.month, fecha.day);
    final jueves = dia.add(Duration(days: 4 - (dia.weekday)));
    final primerDia = DateTime(jueves.year, 1, 1);
    return 1 + (jueves.difference(primerDia).inDays / 7).floor();
  }
}

/// Generador congruente lineal simple: aleatoriedad *determinista* a partir de
/// una semilla (misma semilla → misma secuencia). Suficiente para simular
/// rivales estables durante la semana.
class _Lcg {
  int _estado;
  _Lcg(int semilla) : _estado = (semilla * 2654435761) & 0x7fffffff;

  /// Devuelve un entero en [0, max).
  int next(int max) {
    _estado = (_estado * 1103515245 + 12345) & 0x7fffffff;
    return _estado % max;
  }
}
