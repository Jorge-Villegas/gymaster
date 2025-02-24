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
      body: BlocBuilder<EjercicioCubit, EjercicioState>(
        builder: (context, state) {
          if (state is EjercicioGetAllSuccess) {
            return buildEjercicioList(state);
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
    );
  }

  Widget buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: 10, // Número de elementos de carga
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2.5),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 27,
                backgroundColor: Color(0xffF2F2F2),
              ),
              title: Container(
                width: double.infinity,
                height: 10.0,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildEjercicioList(EjercicioGetAllSuccess state) {
    return ListView.separated(
      separatorBuilder: (_, index) => const SizedBox(height: 5),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      itemCount: state.ejercicios.length,
      itemBuilder: (context, i) {
        // Limita el retraso máximo a 1500 milisegundos (10 * 100)
        final delay = Duration(milliseconds: 100 * (i < 10 ? i : 10));
        final ejercicio = state.ejercicios[i];
        final imagenDireccion =
            ejercicio.imagenDireccion?.isNotEmpty == true
                ? ejercicio.imagenDireccion!
                : AppConfig.defaultImagePath;
        return FadeInLeft(
          duration: delay,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2.5),
            decoration: BoxDecoration(
              color:
                  ejercicio.seleccionado
                      ? Colors.green.withAlpha(51)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child:
                          VerificadorTipoArchivo.esSvg(imagenDireccion)
                              ? SvgPicture.asset(
                                imagenDireccion,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : Image.asset(
                                imagenDireccion,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                    ),
                  ),
                  if (ejercicio.seleccionado)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(
                            230,
                          ), // Fondo semitransparente
                          shape: BoxShape.circle,
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(ejercicio.nombre),
              onTap: () {
                //TODO: SOLUCIONAR ESTO
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
