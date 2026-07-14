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
import 'package:gymaster/shared/widgets/cabecera_reutilizable.dart';
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

  /// Realiza búsqueda de músculos
  void _realizarBusqueda(String query) {
    if (query.trim().isEmpty) {
      // Si está vacío, mostrar todos los músculos
      context.read<MusculoCubit>().getAllMusculo();
      return;
    }

    // TODO: Implementar búsqueda filtrada en el cubit si es necesario
    // Por ahora mantiene la funcionalidad existente
    context.read<MusculoCubit>().getAllMusculo();

    // Aquí puedes agregar lógica de filtrado local si es necesario
    debugPrint('🔍 Buscando músculos: $query');
  }

  /// Limpia la búsqueda y recarga músculos
  void _limpiarBusqueda() {
    context.read<MusculoCubit>().getAllMusculo();
    debugPrint('🧹 Búsqueda limpiada');
  }

  @override
  Widget build(BuildContext context) {
    // Llama al método para cargar los músculos al construir el widget
    context.read<MusculoCubit>().getAllMusculo();

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
              CabeceraReutilizable(
                titulo: '¡Elige tu enfoque!',
                subtitulo: 'Selecciona el grupo muscular 💪',

                // Botón de volver
                botonIzquierdo: ConfiguracionBotonIzquierdo.volver(),

                // 🔍 Búsqueda expandible de músculos
                busqueda: ConfiguracionBusqueda.musculos(
                  onBusqueda: _realizarBusqueda,
                  onLimpiar: _limpiarBusqueda,
                ),
              ),

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
                                color:
                                    context.gym.brand.withValues(alpha: 0.1),
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
                                        context.gym.brand,
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
                                capitalizarPrimeraLetra(musculo.nombre),
                                style: GymType.section.copyWith(
                                  color: context.gym.ink,
                                  letterSpacing: 1.2,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '¡Vamos a entrenar este grupo!',
                                style: GymType.body.copyWith(
                                  color: context.gym.faint,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Indicador de acción con diseño emocional
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: context.gym.xpInk.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            IconsaxPlusLinear.arrow_right_3,
                            size: 18,
                            color: context.gym.xpInk,
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
