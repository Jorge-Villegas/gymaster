import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';

import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shimmer/shimmer.dart';

class ListarEjerciciosPage extends StatefulWidget {
  final String idMusculo;
  final String idSesion;
  final String nombreMusculo;
  final String idRutina;

  const ListarEjerciciosPage({
    super.key,
    required this.idSesion,
    required this.nombreMusculo,
    required this.idMusculo,
    required this.idRutina,
  });

  @override
  State<ListarEjerciciosPage> createState() => _ListarEjerciciosPageState();
}

class _ListarEjerciciosPageState extends State<ListarEjerciciosPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late TextEditingController _searchController;

  /// Texto de búsqueda para filtrar la lista ya cargada.
  String _query = '';

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _searchController = TextEditingController();
    _cargarEjercicios();
    _loadInitialData();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _headerAnimationController.forward();
  }

  void _cargarEjercicios() {
    context.read<EjercicioCubit>().setEjercicio(
          musculoId: widget.idMusculo,
          rutinaId: widget.idRutina,
        );
  }

  /// Navega a la lista de ejercicios del músculo seleccionado
  void _navegarAAgregarEjercicio(BuildContext context, String ejercicioId,
      String nombreEjercicio, String? imagenDireccion) {
    context.push(
      '/agregar-ejercicio-rutina/${widget.idRutina}/$ejercicioId/$nombreEjercicio/${widget.idSesion}',
      extra: {
        'ejercicioImagenDireccion': imagenDireccion,
      },
    );
  }

  /// Encabezado simple: volver + título centrado + búsqueda temática.
  Widget _construirHeaderEmocional(BuildContext context) {
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
          Row(
            children: [
              IconButton(
                icon: const Icon(IconsaxPlusLinear.arrow_left_1),
                color: c.ink,
                tooltip: 'Volver',
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: Text(
                  'Elige tu ejercicio',
                  textAlign: TextAlign.center,
                  style: GymType.title.copyWith(color: c.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (q) => setState(() => _query = q),
              style: GymType.body.copyWith(color: c.ink),
              decoration: InputDecoration(
                hintText: 'Buscar ejercicios...',
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
              _construirHeaderEmocional(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocBuilder<EjercicioCubit, EjercicioState>(
                    builder: (context, state) {
                      if (state is EjercicioGetAllSuccess) {
                        return _buildEjercicioList(context, state.ejercicios);
                      }
                      if (state is EjercicioError) {
                        return _buildErrorState(context, state.message);
                      }
                      if (state is EjercicioLoading) {
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
              onPressed: () => context.read<EjercicioCubit>().setEjercicio(
                    musculoId: widget.idMusculo,
                    rutinaId: widget.idRutina,
                  ),
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
  /// imagen SVG tintada o foto recortada, con respaldo si no hay/falla imagen.
  Widget _chipImagen(GymColors g, String? ruta, bool isSvg) {
    Widget respaldo() =>
        Icon(IconsaxPlusLinear.weight, color: g.brand, size: 28);
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: g.brandSoft,
        borderRadius: GymRadius.rSm,
      ),
      child: (ruta == null || ruta.isEmpty)
          ? respaldo()
          : (isSvg
              ? SvgPicture.asset(
                  ruta,
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(g.brand, BlendMode.srcIn),
                  placeholderBuilder: (_) => respaldo(),
                )
              : ClipRRect(
                  borderRadius: GymRadius.rSm,
                  child: Image.asset(
                    ruta,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => respaldo(),
                  ),
                )),
    );
  }

  /// Construye la lista de músculos con diseño emocional coherente
  Widget _buildEjercicioList(BuildContext context, List<dynamic> ejercicios) {
    final q = _query.trim().toLowerCase();
    final buscando = q.isNotEmpty;
    final lista = buscando
        ? ejercicios
            .where((e) => (e.nombre as String).toLowerCase().contains(q))
            .toList()
        : ejercicios;

    if (lista.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: context.gym.brand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  buscando
                      ? IconsaxPlusLinear.search_normal
                      : IconsaxPlusLinear.weight,
                  size: 40,
                  color: context.gym.brand,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                buscando ? 'Sin coincidencias' : 'No hay ejercicios disponibles',
                style: GymType.section.copyWith(
                  color: context.gym.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                buscando
                    ? 'No encontramos ejercicios para "${_query.trim()}".'
                    : 'Parece que no hay ejercicios para este grupo muscular.',
                textAlign: TextAlign.center,
                style: GymType.body.copyWith(
                  color: context.gym.faint,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SlideInUp(
      duration: const Duration(milliseconds: 600),
      child: ListView.builder(
        itemCount: lista.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, i) {
          final ejercicio = lista[i];
          final isSvg =
              VerificadorTipoArchivo.esSvg(ejercicio.imagenDireccion ?? '');

          final g = context.gym;
          final seleccionado = ejercicio.seleccionado as bool;

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
                  onTap: seleccionado
                      ? null // Deshabilitado si ya está agregado
                      : () => _navegarAAgregarEjercicio(context, ejercicio.id,
                          ejercicio.nombre, ejercicio.imagenDireccion),
                  child: Opacity(
                    opacity: seleccionado ? 0.5 : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          _chipImagen(g, ejercicio.imagenDireccion, isSvg),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  TextFormatter.capitalize(ejercicio.nombre),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      GymType.section.copyWith(color: g.ink),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  TextFormatter.capitalize(
                                      widget.nombreMusculo),
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
                          seleccionado
                              ? Icon(IconsaxPlusLinear.tick_circle,
                                  size: 20, color: g.brand)
                              : Icon(IconsaxPlusLinear.arrow_right_3,
                                  size: 18, color: g.faint),
                        ],
                      ),
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
