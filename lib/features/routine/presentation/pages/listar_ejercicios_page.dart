import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/config/app_config.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:shimmer/shimmer.dart';

class ListarEjerciciosPage extends StatelessWidget {
  final String musculoId;
  final String sessionId;
  final String nombreMusculo;
  final String rutinaId;

  const ListarEjerciciosPage({
    super.key,
    required this.sessionId,
    required this.nombreMusculo,
    required this.musculoId,
    required this.rutinaId,
  });

  @override
  Widget build(BuildContext context) {
    context.read<EjercicioCubit>().setEjercicio(
          musculoId: musculoId,
          rutinaId: rutinaId,
        );
    return Scaffold(
      appBar: AppBar(title: Text(TextFormatter.capitalize(nombreMusculo))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<EjercicioCubit, EjercicioState>(
          builder: (context, state) {
            if (state is EjercicioGetAllSuccess) {
              return buildEjercicioList(context, state);
            }
            if (state is EjercicioLoading) {
              return buildShimmerLoadingEffect();
            }
            if (state is EjercicioError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Ocurrio un error inesperado'));
            }
          },
        ),
      ),
    );
  }

  Widget buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10, // Número de elementos de carga
        itemBuilder: (context, i) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 27,
                backgroundColor: Colors.white,
              ),
              title: Container(
                width: double.infinity,
                height: 16.0,
                color: Colors.white,
              ),
              trailing: const SizedBox(
                  width: 24, height: 24), // Espacio para el icono
            ),
          );
        },
      ),
    );
  }

  Widget buildEjercicioList(
      BuildContext context, EjercicioGetAllSuccess state) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: state.ejercicios.length,
      itemBuilder: (context, i) {
        final delay =
            Duration(milliseconds: 50 * (i < 15 ? i : 15)); // Ajustar animación
        final ejercicio = state.ejercicios[i];
        final imagenDireccion = ejercicio.imagenDireccion?.isNotEmpty == true
            ? ejercicio.imagenDireccion!
            : AppConfig.defaultImagePath;
        final bool isSvg = VerificadorTipoArchivo.esSvg(imagenDireccion);

        return FadeInLeft(
          duration: delay,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            elevation: ejercicio.seleccionado
                ? 3
                : 1, // Mayor elevación si está seleccionado
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                // Borde coloreado si está seleccionado
                color: ejercicio.seleccionado
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              leading: Hero(
                // Añadir Hero aquí
                tag: 'exercise-image-${ejercicio.id}', // Tag único
                child: CircleAvatar(
                  radius: 27,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  child: ClipOval(
                    child: isSvg
                        ? SvgPicture.asset(
                            imagenDireccion,
                            fit: BoxFit.cover,
                            width: 54,
                            height: 54,
                            placeholderBuilder: (context) =>
                                const CircularProgressIndicator(
                                    strokeWidth: 2), // Placeholder para SVG
                            // ignore: deprecated_member_use
                            color: theme.iconTheme.color,
                          )
                        : Image.asset(
                            imagenDireccion,
                            fit: BoxFit.cover,
                            width: 54,
                            height: 54,
                            errorBuilder: (context, error, stackTrace) {
                              // Placeholder en caso de error al cargar la imagen
                              return Icon(Icons.image_not_supported,
                                  color: theme.colorScheme.onSurfaceVariant);
                            },
                          ),
                  ),
                ),
              ),
              title: Text(
                ejercicio.nombre,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: ejercicio.seleccionado
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: ejercicio.seleccionado
                  ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                  : const Icon(Icons.add_circle_outline),
              onTap: ejercicio.seleccionado
                  ? null
                  : () {
                      print('ListarEjerciciosPage -> sesionId: $sessionId');
                      context.push(
                        '/agregar-ejercicio-rutina/$rutinaId/${ejercicio.id}/${ejercicio.nombre}/$sessionId',
                        extra: {
                          'ejercicioImagenDireccion': ejercicio.imagenDireccion,
                        },
                      );
                    },
            ),
          ),
        );
      },
    );
  }
}
