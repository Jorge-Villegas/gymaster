import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/shared/utils/string_utils.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailPage({
    super.key,
    required this.exercise,
  });

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildEmotionalAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            sliver: SliverToBoxAdapter(
              child: _buildEmotionalContent(context),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildEmotionalFAB(context),
    );
  }

  /// AppBar emocional siguiendo diseño coherente con el catálogo
  Widget _buildEmotionalAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.5,
      stretch: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: FadeInLeft(
        duration: const Duration(milliseconds: 600),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => context.go('/exercise-catalog'),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            padding: const EdgeInsets.all(8),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              capitalizarPrimeraLetra(widget.exercise.name),
              style: EstilosTextoEmocional.energetico.copyWith(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        background: Hero(
          tag: 'exercise-image-${widget.exercise.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildExerciseImage(widget.exercise.imagePath),
              // Overlay sutil para legibilidad
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.3),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Contenido emocional siguiendo principios UX
  Widget _buildEmotionalContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // Sección de músculos objetivo con diseño emocional
        _buildEmotionalMuscleSection(),

        const SizedBox(height: 32),

        // Descripción con diseño emocional
        _buildEmotionalDescription(),

        // Variaciones si existen
        if (widget.exercise.variations.isNotEmpty) ...[
          const SizedBox(height: 32),
          _buildEmotionalVariations(),
        ],

        const SizedBox(height: 120), // Espacio para FAB
      ],
    );
  }

  /// Sección de músculos objetivo con diseño emocional
  Widget _buildEmotionalMuscleSection() {
    return FadeInRight(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título con icono emocional
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconsaxPlusLinear.activity,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Músculos Trabajados 💪',
                    style: TextStyle(
                      letterSpacing: 1.2,
                      height: 1.1,
                      fontSize: 20,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Chips de músculos con diseño emocional
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: widget.exercise.targetMuscles.map((muscle) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        IconsaxPlusLinear.weight,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        capitalizarPrimeraLetra(muscle),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Descripción con diseño emocional
  Widget _buildEmotionalDescription() {
    return FadeInLeft(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título con icono emocional
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.energyOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconsaxPlusLinear.document_text,
                    color: AppColors.energyOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Descripción del Ejercicio 📖',
                    style: TextStyle(
                      letterSpacing: 1.2,
                      height: 1.1,
                      fontSize: 20,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.exercise.description.isNotEmpty
                  ? capitalizarPrimeraLetra(widget.exercise.description)
                  : '¡Este ejercicio te ayudará a fortalecer y desarrollar los músculos trabajados de manera efectiva! 💪✨',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Variaciones con diseño emocional
  Widget _buildEmotionalVariations() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título con icono emocional
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconsaxPlusLinear.refresh,
                    color: AppColors.successGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Variaciones Disponibles 🔄',
                    style: EstilosTextoEmocional.energetico.copyWith(
                      fontSize: 20,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...widget.exercise.variations.asMap().entries.map((entry) {
              final index = entry.key;
              final variation = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: EstilosTextoEmocional.energetico.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        capitalizarPrimeraLetra(variation),
                        style: EstilosTextoEmocional.amigable.copyWith(
                          fontSize: 15,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// FAB emocional con animación
  Widget _buildEmotionalFAB(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 800),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor:
              _isFavorite ? AppColors.motivationRed : AppColors.primary,
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });

            // Mostrar feedback emocional
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isFavorite
                      ? '¡Ejercicio agregado a favoritos! ❤️'
                      : 'Ejercicio removido de favoritos 💔',
                  style: EstilosTextoEmocional.aliento
                      .copyWith(color: Colors.white),
                ),
                backgroundColor: _isFavorite
                    ? AppColors.motivationRed
                    : AppColors.textSecondary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _isFavorite ? IconsaxPlusLinear.heart : IconsaxPlusLinear.heart,
              key: ValueKey(_isFavorite),
              color: Colors.white,
              size: 24,
            ),
          ),
          label: Text(
            _isFavorite ? 'En Favoritos ❤️' : 'Agregar a Favoritos',
            style: EstilosTextoEmocional.aliento.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Imagen del ejercicio con manejo de errores emocional
  Widget _buildExerciseImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconsaxPlusLinear.weight,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                '¡Imagen próximamente! 💪',
                style: EstilosTextoEmocional.aliento.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (VerificadorTipoArchivo.esSvg(imagePath)) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primary.withValues(alpha: 0.8),
            BlendMode.srcATop,
          ),
        ),
      );
    }

    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[400],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconsaxPlusLinear.danger,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'Error al cargar imagen 😔',
                  style: EstilosTextoEmocional.recuperacion.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
