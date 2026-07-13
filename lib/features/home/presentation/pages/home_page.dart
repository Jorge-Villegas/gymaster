import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/home/domain/gamificacion.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/presentation/cubit/record_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/record_state.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';

/// Pantalla de inicio gamificada (mascota + racha + XP + accesos rápidos).
/// Los datos (racha, XP, nivel, logros, semana) se derivan del historial real
/// de rutinas completadas mediante [Gamificacion].
class HomePage extends StatefulWidget {
  /// Salta a la pestaña de rutinas para empezar a entrenar.
  final VoidCallback? onEntrenar;

  const HomePage({super.key, this.onEntrenar});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Carga el historial para calcular la gamificación.
    context.read<RecordCubit>().getAllRutinas();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<RecordCubit, RecordState>(
          builder: (context, state) {
            final rutinas =
                state is RecordLoaded ? state.rutinas : <RecordRutina>[];
            final g = Gamificacion.desde(rutinas);
            return _contenido(context, g);
          },
        ),
      ),
    );
  }

  Widget _contenido(BuildContext context, Gamificacion g) {
    final c = context.gym;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('¡Hola, Jorge! 👋', style: GymType.display.copyWith(color: c.ink)),
        Text('Tu rata está lista para entrenar',
            style: GymType.body.copyWith(color: c.muted)),
        const SizedBox(height: 16),
        _hero(context, g),
        const SizedBox(height: 14),
        GymButton(
          label: '💪 Entrenar hoy',
          onPressed: widget.onEntrenar,
        ),
        const GymSectionHeader('Tu progreso'),
        GymCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Nivel ${g.nivel} · ${g.nivelNombre}',
                        style: GymType.bodyStrong.copyWith(
                            color: c.ink, fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 8),
                  GymPill('⭐ ${g.xpEnNivel} / ${g.xpPorNivel} XP',
                      tone: GymTone.xp),
                ],
              ),
              const SizedBox(height: 10),
              GymXpBar(value: g.progresoNivel),
              const SizedBox(height: 7),
              Text('${g.xpParaSiguiente} XP para el Nivel ${g.nivel + 1}',
                  style: GymType.label.copyWith(color: c.muted)),
            ],
          ),
        ),
        const GymSectionHeader('Esta semana'),
        GymCard(child: _weekRow(context, g)),
        const GymSectionHeader('Resumen'),
        Row(
          children: [
            Expanded(
                child: GymMetricCard('${g.entrenos}', 'Entrenos',
                    valueColor: c.brand)),
            const SizedBox(width: 10),
            Expanded(
                child: GymMetricCard('${g.racha}', 'Racha 🔥',
                    valueColor: c.coral)),
            const SizedBox(width: 10),
            Expanded(
                child: GymMetricCard('${g.logros}', 'Logros',
                    valueColor: c.xpInk)),
          ],
        ),
      ],
    );
  }

  Widget _hero(BuildContext context, Gamificacion g) {
    final c = context.gym;
    final tieneRacha = g.racha > 0;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.brand, c.brandInk],
        ),
        borderRadius: GymRadius.rLg,
        boxShadow: [
          BoxShadow(
              color: c.brandInk.withValues(alpha: .4),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const SizedBox(width: 96, height: 96, child: RatMascot()),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    tieneRacha
                        ? '¡Racha de ${g.racha} día${g.racha == 1 ? '' : 's'}!'
                        : '¡Empieza tu racha!',
                    style: GymType.title.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                    tieneRacha
                        ? 'No la rompas hoy. ${g.xpParaSiguiente} XP para el Nivel ${g.nivel + 1}.'
                        : 'Completa un entreno hoy y enciende el fuego. 🔥',
                    style: GymType.body.copyWith(color: Colors.white)),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                      tieneRacha
                          ? '🔥 ${g.racha} día${g.racha == 1 ? '' : 's'} seguidos'
                          : '🔥 0 días',
                      style: GymType.bodyStrong.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekRow(BuildContext context, Gamificacion g) {
    final c = context.gym;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: g.semana.map((d) {
        final done = d.hecho;
        final today = d.esHoy;
        return Column(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: done ? c.brand : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: done ? c.brand : (today ? c.coral : c.lineStrong),
                  width: 3,
                ),
              ),
              child: Text(d.etiqueta,
                  style: GymType.label.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color:
                          done ? Colors.white : (today ? c.coral : c.faint))),
            ),
            const SizedBox(height: 5),
            Text(done ? '✓' : (today ? 'hoy' : '—'),
                style: GymType.micro.copyWith(color: c.muted)),
          ],
        );
      }).toList(),
    );
  }
}
