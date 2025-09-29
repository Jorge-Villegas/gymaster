import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_cubit.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_state.dart';
import 'package:gymaster/shared/utils/string_utils.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/shared/widgets/cabecera_reutilizable.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shimmer/shimmer.dart';

/// Página dedicada para mostrar todos los ejercicios favoritos del usuario
/// Implementa diseño emocional con animaciones y feedback positivo
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Cargar favoritos y animar entrada
    _loadFavorites();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  void _loadFavorites() {
    context.read<FavoritoEjercicioCubit>().obtenerTodosLosEjerciciosFavoritos();
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _listAnimationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          _buildFavoritesContent(),
        ],
      ),
    );
  }

  /// Header emocional con diseño consistente
  Widget _buildSliverAppBar() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.fondoPrincipalClaro,
              Colors.white,
              AppColors.fondoPrincipalClaro.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: _construirCabeceraReutilizable(context),
        ),
      ),
    );
  }

  /// Construye la cabecera usando el componente reutilizable
  Widget _construirCabeceraReutilizable(BuildContext context) {
    // Obtener información dinámica del subtítulo
    final cantidad = context.read<FavoritoEjercicioCubit>().cantidadFavoritos;
    final subtitulo = cantidad == 0
        ? '¡Agrega tus ejercicios favoritos! ❤️'
        : '$cantidad favorito${cantidad != 1 ? 's' : ''} guardado${cantidad != 1 ? 's' : ''} ✨';

    return CabeceraReutilizable(
      titulo: 'Ejercicios Favoritos',
      subtitulo: subtitulo,
      botonIzquierdo: ConfiguracionBotonIzquierdo.menu(),
      accionesDerecha: [
        // Icono temático decorativo
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red.shade600.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.red.shade600.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            IconsaxPlusBold.heart,
            color: Colors.red.shade600,
            size: 24,
          ),
        ),
      ],
    );
  }

  /// Contenido principal con lista de ejercicios favoritos
  Widget _buildFavoritesContent() {
    return BlocBuilder<FavoritoEjercicioCubit, FavoritoEjercicioState>(
      builder: (context, state) {
        return switch (state) {
          FavoritoEjercicioInitial() => _buildLoadingSliver(),
          FavoritoEjercicioLoading() => _buildLoadingSliver(),
          FavoritoEjercicioObtenerTodosSuccess() =>
            _buildSuccessSliver(state.ejerciciosFavoritos),
          FavoritoEjercicioError() => _buildErrorSliver(state.mensaje),
          _ => _buildLoadingSliver(),
        };
      },
    );
  }

  /// Lista de ejercicios favoritos exitosa
  Widget _buildSuccessSliver(List<Exercise> ejerciciosFavoritos) {
    if (ejerciciosFavoritos.isEmpty) {
      return _buildEmptyStateSliver();
    }

    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final exercise = ejerciciosFavoritos[index];
            return FadeInUp(
              duration: Duration(milliseconds: 400 + (index * 100)),
              controller: (controller) => _listAnimationController,
              child: _buildFavoriteExerciseCard(exercise, index),
            );
          },
          childCount: ejerciciosFavoritos.length,
        ),
      ),
    );
  }

  /// Tarjeta de ejercicio favorito con animaciones
  Widget _buildFavoriteExerciseCard(Exercise exercise, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primario.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/exercise-detail', extra: exercise);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Imagen del ejercicio
                Hero(
                  tag: 'favorite-exercise-image-${exercise.id}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primario.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildExerciseImage(exercise.imagePath),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Información del ejercicio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizarPrimeraLetra(exercise.name),
                        style: EstilosTextoEmocional.energetico.copyWith(
                          fontSize: 18,
                          color: AppColors.primario,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Músculos objetivo
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: exercise.targetMuscles.take(3).map((muscle) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secundarioClaro
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.secundarioClaro
                                    .withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              capitalizarPrimeraLetra(muscle),
                              style:
                                  EstilosTextoEmocional.recuperacion.copyWith(
                                fontSize: 12,
                                color: AppColors.secundarioClaro,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      // Descripción breve
                      Text(
                        exercise.description,
                        style: EstilosTextoEmocional.recuperacion.copyWith(
                          fontSize: 14,
                          color: AppColors.textoTerciario,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Botón de remover de favoritos
                _buildRemoveFavoriteButton(exercise),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Botón para remover de favoritos con confirmación
  Widget _buildRemoveFavoriteButton(Exercise exercise) {
    return GestureDetector(
      onTap: () => _showRemoveConfirmation(exercise),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.acento.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.acento.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          IconsaxPlusBold.heart,
          color: AppColors.acento,
          size: 20,
        ),
      ),
    );
  }

  /// Diálogo de confirmación para remover favorito
  void _showRemoveConfirmation(Exercise exercise) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              IconsaxPlusLinear.heart_slash,
              color: AppColors.acento,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Remover Favorito',
                style: EstilosTextoEmocional.energetico.copyWith(
                  fontSize: 18,
                  color: AppColors.textoPrincipalOscuro,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas remover "${exercise.name}" de tus favoritos?',
          style: EstilosTextoEmocional.recuperacion.copyWith(
            fontSize: 16,
            color: AppColors.textoTerciario,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancelar',
              style: EstilosTextoEmocional.aliento.copyWith(
                color: AppColors.textoTerciario,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await context
                  .read<FavoritoEjercicioCubit>()
                  .removerEjercicioDeFavoritos(exercise.id);

              // Recargar lista
              _loadFavorites();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.acento,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Remover',
              style: EstilosTextoEmocional.aliento.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Estado vacío cuando no hay favoritos
  Widget _buildEmptyStateSliver() {
    return SliverFillRemaining(
      child: Center(
        child: FadeInUp(
          duration: const Duration(milliseconds: 800),
          controller: (controller) => _listAnimationController,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primario.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    IconsaxPlusLinear.heart,
                    size: 64,
                    color: AppColors.primario.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '¡Aún no tienes favoritos!',
                  style: EstilosTextoEmocional.motivacional.copyWith(
                    fontSize: 24,
                    color: AppColors.textoPrincipalOscuro,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Explora el catálogo de ejercicios y agrega tus favoritos tocando el ❤️ en cada ejercicio.',
                  style: EstilosTextoEmocional.recuperacion.copyWith(
                    fontSize: 16,
                    color: AppColors.textoTerciario,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/exercise-catalog');
                  },
                  icon: Icon(IconsaxPlusLinear.search_normal_1),
                  label: Text('Explorar Ejercicios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primario,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Estado de carga con skeletons
  Widget _buildLoadingSliver() {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildLoadingSkeleton(),
          childCount: 5,
        ),
      ),
    );
  }

  /// Skeleton de carga para tarjetas
  Widget _buildLoadingSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primario.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 16,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Estado de error
  Widget _buildErrorSliver(String mensaje) {
    return SliverFillRemaining(
      child: Center(
        child: FadeInUp(
          duration: const Duration(milliseconds: 800),
          controller: (controller) => _listAnimationController,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconsaxPlusLinear.emoji_sad,
                  size: 64,
                  color: AppColors.acento.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 24),
                Text(
                  'Oops! Algo salió mal',
                  style: EstilosTextoEmocional.motivacional.copyWith(
                    fontSize: 24,
                    color: AppColors.textoPrincipalOscuro,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  mensaje,
                  style: EstilosTextoEmocional.recuperacion.copyWith(
                    fontSize: 16,
                    color: AppColors.textoTerciario,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _loadFavorites,
                  icon: Icon(IconsaxPlusLinear.refresh),
                  label: Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primario,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye la imagen del ejercicio con manejo de errores
  Widget _buildExerciseImage(String imagePath) {
    if (VerificadorTipoArchivo.esSvg(imagePath)) {
      return SvgPicture.asset(
        imagePath,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => _buildImagePlaceholder(),
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
      );
    }
  }

  /// Placeholder para imágenes que no cargan
  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primario.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        IconsaxPlusLinear.image,
        color: AppColors.primario.withValues(alpha: 0.5),
        size: 32,
      ),
    );
  }
}
