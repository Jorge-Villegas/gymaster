import 'package:animate_do/animate_do.dart';
import 'package:gymaster/core/config/app_config.dart';
import 'package:gymaster/core/utils/text_formatter.dart';
import 'package:gymaster/core/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_rutina_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:animate_do/animate_do.dart';
import 'package:gymaster/core/config/app_config.dart';
import 'package:gymaster/core/utils/text_formatter.dart';
import 'package:gymaster/core/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_rutina_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ListarEjerciciosPage extends StatelessWidget {
  final String musculoId;
  final String nombreMusculo;
  final String rutinaId;

  const ListarEjerciciosPage({
    super.key,
    required this.nombreMusculo,
    required this.musculoId,
    required this.rutinaId,
  });

  @override
  Widget build(BuildContext context) {
    context.read<EjercicioCubit>().setEjercicio(musculoId: musculoId);
    return Scaffold(
      appBar: AppBar(
        title: Text(TextFormatter.capitalize(nombreMusculo)),
      ),
      body: BlocBuilder<EjercicioCubit, EjercicioState>(
        builder: (context, state) {
          if (state is EjercicioGetAllSuccess) {
            return ListView.separated(
              separatorBuilder: (_, index) => const SizedBox(height: 5),
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: state.ejercicios.length,
              itemBuilder: (context, i) {
                // Limita el retraso máximo a 1500 milisegundos (10 * 100)
                final delay = Duration(milliseconds: 100 * (i < 10 ? i : 10));
                final ejercicio = state.ejercicios[i];
                final imagenDireccion = ejercicio.imagenDireccion?.isNotEmpty == true
                    ? ejercicio.imagenDireccion!
                    : AppConfig.defaultImagePath;
                return FadeInLeft(
                  duration: delay,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.5),
                    child: ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: VerificadorTipoArchivo.esSvg(imagenDireccion)
                              ? SvgPicture.asset(
                                  imagenDireccion,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  imagenDireccion,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                        ),
                      ),
                      title: Text(ejercicio.nombre),
                      onTap: () {
                        // Aquí podrías manejar la lógica de navegación o detalle del ejercicio
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AgregarEjercicioRutinaPage(
                              ejercicioId: ejercicio.id,
                              ejercicioImagenDireccion: ejercicio.imagenDireccion,
                              ejercicioNombre: ejercicio.nombre,
                              rutinaId: rutinaId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
          if (state is EjercicioError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('Ocurrio un error inesperado'),
            );
          }
        },
      ),
    );
  }
}