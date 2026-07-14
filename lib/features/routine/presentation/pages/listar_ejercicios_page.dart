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
  late AnimationController _searchAnimationController;
  late TextEditingController _searchController;
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _searchController = TextEditingController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _searchAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _headerAnimationController.forward();
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

  /// Construye el header emocional con búsqueda expandible
  Widget _construirHeaderEmocional(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: AnimatedBuilder(
          animation: _searchAnimationController,
          builder: (context, child) {
            return Row(
              children: [
                // Botón de volver
                Container(
                  decoration: BoxDecoration(
                    color: context.gym.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: context.gym.faint.withValues(alpha: 0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      IconsaxPlusLinear.arrow_left_1,
                      color: context.gym.xpInk,
                      size: 20,
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 16),
                // Contenido principal (título o búsqueda)
                Expanded(
                  child: _isSearchExpanded
                      ? _buildExpandedSearchField()
                      : _buildTitleSection(),
                ),
                const SizedBox(width: 16),
                // Botón de búsqueda
                _buildSearchButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Sección del título cuando no está en modo búsqueda
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Elige tu ejercicio!',
          style: GymType.section.copyWith(
            color: context.gym.ink,
            height: 1.1,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          TextFormatter.capitalize(widget.nombreMusculo),
          style: GymType.body.copyWith(
            color: context.gym.muted,
          ),
        ),
      ],
    );
  }

  /// Campo de búsqueda expandido con animación
  Widget _buildExpandedSearchField() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeOutCubic,
      )),
      child: Container(
        decoration: BoxDecoration(
          color: context.gym.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.gym.brand.withValues(alpha: 0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
          border: Border.all(
            color: context.gym.brand.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: GymType.body.copyWith(
            color: context.gym.ink,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar ejercicios...',
            hintStyle: GymType.body.copyWith(
              color: context.gym.faint,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.gym.brand.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                IconsaxPlusLinear.search_normal_1,
                color: context.gym.brand,
                size: 20,
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.gym.faint.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        IconsaxPlusLinear.close_circle,
                        color: context.gym.faint,
                        size: 16,
                      ),
                    ),
                    onPressed: _limpiarBusqueda,
                  )
                : null,
          ),
          onChanged: _realizarBusqueda,
          onSubmitted: _realizarBusqueda,
        ),
      ),
    );
  }

  /// Botón de búsqueda con animación
  Widget _buildSearchButton() {
    return GestureDetector(
      onTap: _toggleSearch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _isSearchExpanded ? context.gym.xpInk : context.gym.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: context.gym.xpInk.withValues(alpha: 0.2),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            _isSearchExpanded
                ? IconsaxPlusLinear.close_circle
                : IconsaxPlusLinear.search_normal_1,
            key: ValueKey(_isSearchExpanded),
            color: _isSearchExpanded ? Colors.white : context.gym.xpInk,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// Toggle del estado de búsqueda con animación
  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });

    if (_isSearchExpanded) {
      _searchAnimationController.forward();
    } else {
      _searchAnimationController.reverse();
      if (_searchController.text.isNotEmpty) {
        _limpiarBusqueda();
      }
    }
  }

  /// Realiza búsqueda con filtrado de músculos
  void _realizarBusqueda(String query) {
    // Aquí puedes implementar la lógica de filtrado de músculos
    // Por ahora, se puede mostrar un mensaje o filtrar la lista
    if (query.trim().isEmpty) {
      context.read<EjercicioCubit>().setEjercicio(
            musculoId: widget.idMusculo,
            rutinaId: widget.idRutina,
          );
      return;
    }

    // TODO: Implementar búsqueda de ejercicios en el cubit si es necesario
    context.read<EjercicioCubit>().setEjercicio(
          musculoId: widget.idMusculo,
          rutinaId: widget.idRutina,
        );
  }

  /// Limpia la búsqueda
  void _limpiarBusqueda() {
    setState(() {
      _searchController.clear();
    });
    context.read<EjercicioCubit>().setEjercicio(
          musculoId: widget.idMusculo,
          rutinaId: widget.idRutina,
        );
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // Llama al método para cargar los ejercicios al construir el widget
    context.read<EjercicioCubit>().setEjercicio(
          musculoId: widget.idMusculo,
          rutinaId: widget.idRutina,
        );

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

  /// Construye el efecto de carga shimmer con diseño emocional
  Widget _buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: context.gym.surface2,
      highlightColor: context.gym.surface2,
      child: ListView.builder(
        itemCount: 8,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            decoration: BoxDecoration(
              color: context.gym.surface2,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.gym.brand.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Avatar placeholder
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: context.gym.surface2,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Texto placeholder
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.gym.surface2,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14.0,
                          width: 150,
                          decoration: BoxDecoration(
                            color: context.gym.surface2,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Indicador placeholder
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: context.gym.surface2,
                      borderRadius: BorderRadius.circular(12),
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

  /// Construye la lista de músculos con diseño emocional coherente
  Widget _buildEjercicioList(BuildContext context, List<dynamic> ejercicios) {
    if (ejercicios.isEmpty) {
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
                  IconsaxPlusLinear.weight,
                  size: 40,
                  color: context.gym.brand,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No hay ejercicios disponibles',
                style: GymType.section.copyWith(
                  color: context.gym.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Parece que no hay ejercicios para este grupo muscular.',
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
        itemCount: ejercicios.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, i) {
          final ejercicio = ejercicios[i];
          final isSvg =
              VerificadorTipoArchivo.esSvg(ejercicio.imagenDireccion ?? '');

          return FadeInUp(
            duration: Duration(milliseconds: 300 + (i * 100)),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                color: context.gym.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: context.gym.brand.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: ejercicio.seleccionado
                      ? null // Deshabilitado si ya está agregado
                      : () => _navegarAAgregarEjercicio(context, ejercicio.id,
                          ejercicio.nombre, ejercicio.imagenDireccion),
                  child: Opacity(
                    opacity: ejercicio.seleccionado ? 0.5 : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          /// Avatar del músculo con diseño emocional
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      context.gym.brand.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: ejercicio.imagenDireccion != null &&
                                      ejercicio.imagenDireccion!.isNotEmpty
                                  ? (isSvg
                                      ? Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: SvgPicture.asset(
                                            ejercicio.imagenDireccion!,
                                            fit: BoxFit.contain,
                                            colorFilter: ColorFilter.mode(
                                              context.gym.brand,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        )
                                      : Image.asset(
                                          ejercicio.imagenDireccion!,
                                          fit: BoxFit.cover,
                                          width: 64,
                                          height: 64,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                color: context.gym.brand
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Icon(
                                                IconsaxPlusLinear.weight,
                                                color: context.gym.brand,
                                                size: 24,
                                              ),
                                            );
                                          },
                                        ))
                                  : Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: context.gym.brand
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Icon(
                                        IconsaxPlusLinear.weight,
                                        color: context.gym.brand,
                                        size: 24,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  TextFormatter.capitalize(ejercicio.nombre),
                                  style: GymType.section.copyWith(
                                    color: context.gym.ink,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  TextFormatter.capitalize(
                                      widget.nombreMusculo),
                                  style: GymType.body.copyWith(
                                    color: context.gym.faint,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Indicador de acción
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ejercicio.seleccionado
                                  ? context.gym.brand.withValues(alpha: 0.15)
                                  : context.gym.xpInk.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              ejercicio.seleccionado
                                  ? IconsaxPlusLinear.tick_circle
                                  : IconsaxPlusLinear.weight,
                              size: 18,
                              color: ejercicio.seleccionado
                                  ? context.gym.brand
                                  : context.gym.xpInk,
                            ),
                          ),
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
