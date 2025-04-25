import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/widgets/custom_search_delegate.dart';
import 'package:shimmer/shimmer.dart';

class AgregarEjerciciosPage extends StatelessWidget {
  final String rutinaid;
  final String sesionId;

  const AgregarEjerciciosPage({
    super.key,
    required this.rutinaid,
    required this.sesionId,
  });

  @override
  Widget build(BuildContext context) {
    // Llama al método para cargar los músculos al construir el widget
    context.read<MusculoCubit>().getAllMusculo();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Ejercicios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchDelegateCustom());
            },
          ),
        ],
      ),
      body: Padding(
        // Añadir padding general
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MusculoCubit, MusculoState>(
          builder: (context, state) {
            if (state is MusculoLoaded) {
              return buildMusculoList(context, state);
            }
            if (state is MusculoError) {
              return Center(child: Text(state.message));
            }
            if (state is MusculoLoading) {
              return buildShimmerLoadingEffect();
            }
            return const Center(child: Text("Ha sucedido un error inesperado"));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // El sombreado del botón
        elevation: 10,
        onPressed: () {},
        child: const Icon(Icons.add),
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
            // Usar Card para el shimmer también
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            elevation: 1, // Sutil elevación
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 27,
                backgroundColor: Colors.white, // Fondo blanco para shimmer
              ),
              title: Container(
                width: double.infinity,
                height: 16.0, // Altura del texto simulado
                color: Colors.white, // Color del placeholder
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMusculoList(BuildContext context, MusculoLoaded state) {
    return ListView.builder(
      itemCount: state.musculos.length,
      itemBuilder: (context, i) {
        final musculo = state.musculos[i];
        final isSvg = VerificadorTipoArchivo.esSvg(musculo.imagenDirecion);
        return Card(
          // Envolver ListTile en un Card
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          elevation: 2, // Añadir una ligera elevación
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)), // Bordes redondeados
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0), // Ajustar padding interno
            leading: CircleAvatar(
              radius: 27,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .surfaceVariant, // Usar color del tema
              backgroundImage:
                  isSvg ? null : AssetImage(musculo.imagenDirecion),
              child: isSvg
                  ? ClipOval(
                      // Asegurar que el SVG se recorte si es necesario
                      child: SvgPicture.asset(
                        musculo.imagenDirecion,
                        fit: BoxFit.cover, // Ajustar imagen
                        width: 54, // Doble del radio
                        height: 54,
                      ),
                    )
                  : null,
            ),
            title: Text(musculo.nombre,
                style: Theme.of(context).textTheme.labelMedium),
            trailing:
                const Icon(Icons.chevron_right), // Indicador visual de acción
            onTap: () {
              print('AgregarEjerciciosPage -> sesionId: $sesionId');
              context.push(
                '/listar-ejercicios/${musculo.id}/${musculo.nombre}/$rutinaid/$sesionId',
              );
            },
          ),
        );
      },
    );
  }
}
