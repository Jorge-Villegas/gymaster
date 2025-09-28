import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/features/setting/presentation/cubits/app_start/app_start_cubit.dart';
import 'package:gymaster/shared/widgets/barra_navegacion.dart';
import 'package:gymaster/core/theme/app_colors.dart';

class AppStartPage extends StatefulWidget {
  const AppStartPage({super.key});

  @override
  State<AppStartPage> createState() => _AppStartPageState();
}

class _AppStartPageState extends State<AppStartPage> {
  @override
  void initState() {
    super.initState();
    // Verificar el estado inicial de la aplicación
    context.read<AppStartCubit>().checkAppStartState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStartCubit, AppStartState>(
      listener: (context, state) {
        if (state is AppStartShowOnboarding) {
          // Navegar al onboarding
          context.go('/onboarding');
        } else if (state is AppStartShowMainApp) {
          // No navegar, ya estamos en la app principal
          // El widget principal se mostrará automáticamente
        } else if (state is AppStartError) {
          // En caso de error, mostrar snackbar y ir al onboarding por seguridad
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
          context.go('/onboarding');
        }
      },
      child: BlocBuilder<AppStartCubit, AppStartState>(
        builder: (context, state) {
          if (state is AppStartLoading) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Iniciando GyMaster...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          // Por defecto, mostrar la app principal
          return const BottomNavigationBarExampleApp();
        },
      ),
    );
  }
}
