import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/shared/utils/string_utils.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shimmer/shimmer.dart';

class AgregarEjerciciosPage extends StatefulWidget {
  final String rutinaid;
  final String sesionId;

  const AgregarEjerciciosPage({
    super.key,
    required this.rutinaid,
    required this.sesionId,
  });

  @override
  State<AgregarEjerciciosPage> createState() => _AgregarEjerciciosPageState();
}

class _AgregarEjerciciosPageState extends State<AgregarEjerciciosPage> {
  /// Texto de búsqueda para filtrar la lista ya cargada.
  String _query = '';

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  void _cargarDatosIniciales() {
    context.read<MusculoCubit>().getAllMusculo();
  }

  /// Navega a la lista de ejercicios del músculo seleccionado
  void _navegarAListaEjercicios(
      BuildContext context, String musculoId, String musculoNombre) {
    context.push(
        '/listar-ejercicios/$musculoId/$musculoNombre/${widget.rutinaid}/${widget.sesionId}');
  }

  /// Header propio: botón de volver + búsqueda de músculos (sin barra de título).
  Widget _buildHeaderConBusqueda(BuildContext context) {
    final c = context.gym;
    OutlineInputBorder borde(Color color, [double ancho = 1]) =>
        OutlineInputBorder(
          borderRadius: GymRadius.rMd,
          borderSide: BorderSide(color: color, width: ancho),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 12, 8),
      child: Column(
        children: [
          // Encabezado simple: volver + título.
          Row(
            children: [
              IconButton(
                icon: const Icon(IconsaxPlusLinear.arrow_left_1),
                color: c.ink,
                tooltip: 'Volver',
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go('/main?tab=1'),
              ),
              Expanded(
                child: Text('Elige un músculo',
                    textAlign: TextAlign.center,
                    style: GymType.title.copyWith(color: c.ink),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: TextField(
              onChanged: (q) => setState(() => _query = q),
              style: GymType.body.copyWith(color: c.ink),
              decoration: InputDecoration(
                hintText: 'Buscar músculos...',
                hintStyle: GymType.body.copyWith(color: c.faint),
                prefixIcon: Icon(IconsaxPlusLinear.search_normal,
                    color: c.muted, size: 20),
                filled: true,
                fillColor: c.surface,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                enabledBorder: borde(c.line),
                border: borde(c.line),
                focusedBorder: borde(c.brand, 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeaderConBusqueda(context),

              // Lista de músculos
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocBuilder<MusculoCubit, MusculoState>(
                    builder: (context, state) {
                      if (state is MusculoLoaded) {
                        return _buildMusculoList(context, state);
                      }
                      if (state is MusculoError) {
                        return _buildErrorState(context, state.message);
                      }
                      if (state is MusculoLoading) {
                        return _buildShimmerLoadingEffect();
                      }
                      return _buildErrorState(
                          context, "Ha sucedido un error inesperado");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el estado de error con mensaje emocional motivacional
  Widget _buildErrorState(BuildContext context, String mensaje) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.gym.xpInk.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                IconsaxPlusLinear.weight,
                size: 80,
                color: context.gym.xpInk,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '¡No te preocupes!',
              style: GymType.display.copyWith(
                color: context.gym.ink,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                mensaje,
                textAlign: TextAlign.center,
                style: GymType.body.copyWith(
                  color: context.gym.faint,
                ),
              ),
            ),
            const SizedBox(height: 32),
            GymButton(
              label: 'Reintentar',
              icon: IconsaxPlusLinear.refresh,
              size: GymButtonSize.large,
              expand: false,
              onPressed: () => context.read<MusculoCubit>().getAllMusculo(),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el efecto de carga shimmer coherente con la tarjeta real.
  Widget _buildShimmerLoadingEffect() {
    final g = context.gym;
    return Shimmer.fromColors(
      baseColor: g.surface2,
      highlightColor: g.surface,
      child: ListView.builder(
        itemCount: 8,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: g.surface2,
              borderRadius: GymRadius.rMd,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: g.surface,
                      borderRadius: GymRadius.rSm,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: g.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 150,
                          decoration: BoxDecoration(
                            color: g.surface,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Chip de icono 56×56 alineado a [RoutineCard]: fondo suave de marca +
  /// imagen SVG tintada o foto recortada, con respaldo si falla la carga.
  Widget _chipImagen(GymColors g, String ruta, bool isSvg) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: g.brandSoft,
        borderRadius: GymRadius.rSm,
      ),
      child: isSvg
          ? SvgPicture.asset(
              ruta,
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(g.brand, BlendMode.srcIn),
              placeholderBuilder: (_) =>
                  Icon(IconsaxPlusLinear.weight, color: g.brand, size: 28),
            )
          : ClipRRect(
              borderRadius: GymRadius.rSm,
              child: Image.asset(
                ruta,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(IconsaxPlusLinear.weight, color: g.brand, size: 28),
              ),
            ),
    );
  }

  /// Estado vacío cuando la búsqueda no arroja coincidencias.
  Widget _buildSinResultados() {
    final g = context.gym;
    return FadeIn(
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: g.brand.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(IconsaxPlusLinear.search_normal,
                  size: 36, color: g.brand),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin coincidencias',
              style: GymType.section.copyWith(color: g.ink),
            ),
            const SizedBox(height: 8),
            Text(
              'No encontramos músculos para "${_query.trim()}".',
              textAlign: TextAlign.center,
              style: GymType.body.copyWith(color: g.faint),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la lista de músculos con tarjetas del sistema de diseño.
  Widget _buildMusculoList(BuildContext context, MusculoLoaded state) {
    final g = context.gym;
    final q = _query.trim().toLowerCase();
    final musculos = q.isEmpty
        ? state.musculos
        : state.musculos
            .where((m) => m.nombre.toLowerCase().contains(q))
            .toList();

    if (musculos.isEmpty) {
      return _buildSinResultados();
    }

    return SlideInUp(
      duration: const Duration(milliseconds: 600),
      child: ListView.builder(
        itemCount: musculos.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, i) {
          final musculo = musculos[i];
          final isSvg = VerificadorTipoArchivo.esSvg(musculo.imagenDirecion);

          return FadeInUp(
            duration: Duration(milliseconds: 300 + (i * 100)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: g.surface,
                borderRadius: GymRadius.rMd,
                border: Border.all(color: g.line),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: GymRadius.rMd,
                  onTap: () => _navegarAListaEjercicios(
                      context, musculo.id, musculo.nombre),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        _chipImagen(g, musculo.imagenDirecion, isSvg),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                capitalizarPrimeraLetra(musculo.nombre),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GymType.section.copyWith(color: g.ink),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '¡Vamos a entrenar este grupo!',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GymType.label.copyWith(
                                  color: g.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(IconsaxPlusLinear.arrow_right_3,
                            size: 18, color: g.faint),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
