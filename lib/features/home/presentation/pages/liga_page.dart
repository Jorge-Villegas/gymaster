import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/home/domain/gamificacion.dart';
import 'package:gymaster/features/home/domain/liga.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/presentation/cubit/record_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/record_state.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_state.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// Pantalla de Liga fantasma local 🏆. Su encabezado ES el podio (no lleva
/// barra de título) para sentirse única e inmersiva. Compites por XP semanal
/// contra rivales simulados que rotan cada lunes.
class LigaPage extends StatefulWidget {
  const LigaPage({super.key});

  @override
  State<LigaPage> createState() => _LigaPageState();
}

class _LigaPageState extends State<LigaPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecordCubit>().getAllRutinas();
    context.read<OnboardingUsuarioCubit>().obtenerPerfilCompleto();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    final perfilState = context.watch<OnboardingUsuarioCubit>().state;
    final nombre = perfilState is OnboardingUsuarioPerfilCargado
        ? perfilState.perfil.nombreUsuario
        : '';

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: BlocBuilder<RecordCubit, RecordState>(
          builder: (context, state) {
            final rutinas =
                state is RecordLoaded ? state.rutinas : <RecordRutina>[];
            final g = Gamificacion.desde(rutinas);
            final liga = Liga.generar(
              xpSemana: g.xpSemana,
              xpTotal: g.xp,
              nombreUsuario: nombre,
            );
            return _contenido(context, liga);
          },
        ),
      ),
    );
  }

  Widget _contenido(BuildContext context, Liga liga) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _cabeceraPodio(context, liga)),
        _lista(context, liga),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  /// Encabezado único: botón atrás + tier + podio de los 3 primeros.
  Widget _cabeceraPodio(BuildContext context, Liga liga) {
    final c = context.gym;
    final top3 = liga.ranking.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.plumSoft, c.bg],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              GymIconButton(
                icon: IconsaxPlusLinear.arrow_left_1,
                tooltip: 'Volver',
                onTap: () =>
                    context.canPop() ? context.pop() : context.go('/main'),
              ),
              const Spacer(),
              Text('${liga.tier.emoji}  ${liga.tier.nombre}',
                  style: GymType.bodyStrong
                      .copyWith(color: c.plum, fontWeight: FontWeight.w800)),
              const Spacer(),
              const SizedBox(width: 44), // equilibra el botón atrás
            ],
          ),
          const SizedBox(height: 4),
          Text('Ranking semanal',
              style: GymType.label.copyWith(color: c.muted)),
          const SizedBox(height: 12),
          // Podio: 2º - 1º - 3º
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: top3.length > 1
                      ? _puesto(context, top3[1], 2, 84)
                      : const SizedBox()),
              Expanded(
                  child: top3.isNotEmpty
                      ? _puesto(context, top3[0], 1, 108)
                      : const SizedBox()),
              Expanded(
                  child: top3.length > 2
                      ? _puesto(context, top3[2], 3, 68)
                      : const SizedBox()),
            ],
          ),
          const SizedBox(height: 12),
          _bannerEstado(context, liga),
        ],
      ),
    );
  }

  Widget _puesto(BuildContext context, LigaRival r, int pos, double altura) {
    final c = context.gym;
    final medalla = pos == 1 ? '🥇' : (pos == 2 ? '🥈' : '🥉');
    final destacado = r.esUsuario;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(r.emoji, style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 2),
        Text(
          r.esUsuario ? 'Tú' : r.nombre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GymType.label.copyWith(
              color: destacado ? c.brandInk : c.ink,
              fontWeight: FontWeight.w800),
        ),
        Text('${r.xp} XP', style: GymType.micro.copyWith(color: c.muted)),
        const SizedBox(height: 6),
        Container(
          height: altura,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: destacado
                  ? [c.brand, c.brandInk]
                  : [c.surface, c.surface2],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: destacado ? c.brand : c.line),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 8),
          child: Text(medalla, style: const TextStyle(fontSize: 22)),
        ),
      ],
    );
  }

  Widget _bannerEstado(BuildContext context, Liga liga) {
    final c = context.gym;
    final (String texto, Color fg, Color bg) = liga.enZonaAscenso
        ? (
            '🎉 ¡Estás en zona de ascenso! Puesto ${liga.posicionUsuario}',
            c.brandInk,
            c.brandSoft
          )
        : liga.enZonaDescenso
            ? (
                '⚠️ Zona de descenso. Entrena para no bajar de liga',
                c.coralInk,
                c.coralSoft
              )
            : (
                'Puesto ${liga.posicionUsuario} de ${liga.totalParticipantes}. ${liga.xpParaSubir} XP para subir',
                c.plum,
                c.plumSoft
              );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: GymRadius.rMd),
      child: Text(texto,
          textAlign: TextAlign.center,
          style: GymType.label
              .copyWith(color: fg, fontSize: 13, fontWeight: FontWeight.w800)),
    );
  }

  Widget _lista(BuildContext context, Liga liga) {
    final c = context.gym;
    final total = liga.totalParticipantes;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      sliver: SliverList.separated(
        itemCount: total,
        separatorBuilder: (_, i) {
          // Línea divisoria entre zona de ascenso y el resto.
          if (i + 1 == liga.puestosAscenso) {
            return _divisorZona(context, 'ASCENSO', c.brand);
          }
          if (i + 1 == total - liga.puestosDescenso) {
            return _divisorZona(context, 'DESCENSO', c.coral);
          }
          return const SizedBox(height: 8);
        },
        itemBuilder: (context, i) {
          final r = liga.ranking[i];
          return _fila(context, r, i + 1);
        },
      ),
    );
  }

  Widget _divisorZona(BuildContext context, String etiqueta, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: color, thickness: 1.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(etiqueta,
                style: GymType.micro.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1)),
          ),
          Expanded(child: Divider(color: color, thickness: 1.5)),
        ],
      ),
    );
  }

  Widget _fila(BuildContext context, LigaRival r, int pos) {
    final c = context.gym;
    final destacado = r.esUsuario;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: destacado ? c.brandSoft : c.surface,
        borderRadius: GymRadius.rMd,
        border: Border.all(color: destacado ? c.brand : c.line),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text('$pos',
                textAlign: TextAlign.center,
                style: GymType.bodyStrong.copyWith(
                    color: destacado ? c.brandInk : c.muted,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 8),
          Text(r.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              r.esUsuario ? '${r.nombre} (tú)' : r.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GymType.bodyStrong.copyWith(
                  color: destacado ? c.brandInk : c.ink,
                  fontWeight: destacado ? FontWeight.w800 : FontWeight.w700),
            ),
          ),
          Text('${r.xp} XP',
              style: GymType.label.copyWith(
                  color: destacado ? c.brandInk : c.muted,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
