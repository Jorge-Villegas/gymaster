import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RoutineCubit>(context).getAllRoutine();
  }

  @override
  Widget build(BuildContext context) {
    final routineCubit = BlocProvider.of<RoutineCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
      ),
      body: BlocBuilder<RoutineCubit, RoutineState>(
        builder: (context, state) {
          if (state is RoutineLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is RoutineGetAllSuccess) {
            return ListView.builder(
              itemCount: state.routines.length,
              itemBuilder: (context, index) {
                final routine = state.routines[index];
                return ListTile(
                  title: Text(routine.name),
                );
              },
            );
          }
          return const Center(
            child: Text('Error al cargar las rutinas'),
          );
        },
      ),
    );
  }
}
