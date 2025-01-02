import 'package:go_router/go_router.dart';
import 'package:gymaster/core/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/listar_ejercicios_page.dart';
import 'package:gymaster/widgets/custom_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AgregarEjerciciosPage extends StatelessWidget {
  final String rutinaid;

  const AgregarEjerciciosPage({
    super.key,
    required this.rutinaid,
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
              showSearch(
                context: context,
                delegate: SearchDelegateCustom(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MusculoCubit, MusculoState>(
        builder: (context, state) {
          if (state is MusculoLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: state.musculos.length,
              itemBuilder: (context, i) {
                final musculo = state.musculos[i];
                final isSvg =
                    VerificadorTipoArchivo.esSvg(musculo.imagenDirecion);
                debugPrint('----------------->  ${isSvg.toString()}');
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2.5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 27,
                      // Color de fondo del avatar
                      backgroundImage:
                          isSvg ? null : AssetImage(musculo.imagenDirecion),
                      backgroundColor: const Color(0xffF2F2F2),
                      child: isSvg
                          ? SvgPicture.asset(musculo.imagenDirecion)
                          : null,
                    ),
                    title: Text(musculo.nombre),
                    onTap: () {
                      context.push('/listar-ejercicios/${musculo.id}/${musculo.nombre}/$rutinaid');
                    },
                  ),
                );
              },
            );
          }
          if (state is MusculoError) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is MusculoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(
            child: Text("Ha sucedido un error inesperado"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // El sombreado del botón
        elevation: 10,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
