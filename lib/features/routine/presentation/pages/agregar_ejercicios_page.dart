import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
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

class _AgregarEjerciciosPageState extends State<AgregarEjerciciosPage>
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
  void _navegarAListaEjercicios(
      BuildContext context, String musculoId, String musculoNombre) {
    context.push(
        '/listar-ejercicios/$musculoId/$musculoNombre/${widget.rutinaid}/${widget.sesionId}');
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
                    color: AppColors.fondoPrincipalClaro,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textoSecundarioClaro
                            .withValues(alpha: 0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.motivacionPrincipal,
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
          '¡Elige tu enfoque!',
          style: EstilosTextoEmocional.energetico.copyWith(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'Selecciona el grupo muscular 💪',
          style: EstilosTextoEmocional.amigable.copyWith(
            color: AppColors.motivacionPrincipal,
            fontSize: 16,
            fontWeight: FontWeight.w500,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: EstilosTextoEmocional.amigable.copyWith(
            color: AppColors.primary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar músculos...',
            hintStyle: EstilosTextoEmocional.amigable.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.clear_rounded,
                        color: AppColors.textSecondary,
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
          color: _isSearchExpanded
              ? AppColors.motivacionPrincipal
              : AppColors.fondoPrincipalClaro,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.motivacionPrincipal.withValues(alpha: 0.2),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            _isSearchExpanded ? Icons.close_rounded : Icons.search_rounded,
            key: ValueKey(_isSearchExpanded),
            color: _isSearchExpanded
                ? Colors.white
                : AppColors.motivacionPrincipal,
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
      context.read<MusculoCubit>().getAllMusculo();
      return;
    }

    // TODO: Implementar búsqueda de músculos en el cubit si es necesario
    context.read<MusculoCubit>().getAllMusculo();
  }

  /// Limpia la búsqueda
  void _limpiarBusqueda() {
    setState(() {
      _searchController.clear();
    });
    context.read<MusculoCubit>().getAllMusculo();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // Llama al método para cargar los músculos al construir el widget
    context.read<MusculoCubit>().getAllMusculo();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundLight,
              AppColors.fondoPrincipalClaro,
              AppColors.backgroundLight.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header emocional personalizado
              _construirHeaderEmocional(context),
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
                color: AppColors.motivacionPrincipal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                size: 80,
                color: AppColors.motivacionPrincipal,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '¡No te preocupes!',
              style: EstilosTextoEmocional.aliento.copyWith(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                mensaje,
                textAlign: TextAlign.center,
                style: EstilosTextoEmocional.amigable.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ChicletButton(
              texto: 'Reintentar',
              icono: Icons.refresh_rounded,
              tamano: TamanoBotonChiclet.grande,
              estilo: EstiloBotonChiclet.relleno,
              colorFondo: AppColors.motivacionPrincipal,
              onPressed: () => context.read<MusculoCubit>().getAllMusculo(),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el efecto de carga shimmer con diseño emocional
  Widget _buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundLight,
      highlightColor: AppColors.fondoPrincipalClaro,
      child: ListView.builder(
        itemCount: 8,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            decoration: BoxDecoration(
              color: AppColors.fondoPrincipalClaro,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
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
                      color: AppColors.fondoPrincipalClaro,
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
                            color: AppColors.fondoPrincipalClaro,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14.0,
                          width: 150,
                          decoration: BoxDecoration(
                            color: AppColors.fondoPrincipalClaro,
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
                      color: AppColors.fondoPrincipalClaro,
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
  Widget _buildMusculoList(BuildContext context, MusculoLoaded state) {
    return SlideInUp(
      duration: const Duration(milliseconds: 600),
      child: ListView.builder(
        itemCount: state.musculos.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, i) {
          final musculo = state.musculos[i];
          final isSvg = VerificadorTipoArchivo.esSvg(musculo.imagenDirecion);

          return FadeInUp(
            duration: Duration(milliseconds: 300 + (i * 100)),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                color: AppColors.fondoPrincipalClaro,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _navegarAListaEjercicios(
                      context, musculo.id, musculo.nombre),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // Avatar del músculo con diseño emocional
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFEEEEEE), // Fondo #EEEEEE solicitado
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: isSvg
                                ? Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(
                                      musculo.imagenDirecion,
                                      fit: BoxFit.contain,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    musculo.imagenDirecion,
                                    fit: BoxFit.cover,
                                    width: 64,
                                    height: 64,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Información del músculo con tipografía emocional
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                musculo.nombre,
                                style:
                                    EstilosTextoEmocional.energetico.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '¡Vamos a entrenar este grupo!',
                                style: EstilosTextoEmocional.amigable.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Indicador de acción con diseño emocional
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.logroDesbloqueado
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: AppColors.logroDesbloqueado,
                          ),
                        ),
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
