import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/shared/utils/snackbar_helper.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AgregarRutinaPage extends StatefulWidget {
  const AgregarRutinaPage({super.key});

  @override
  State<AgregarRutinaPage> createState() => _AgregarRutinaPageState();
}

class _AgregarRutinaPageState extends State<AgregarRutinaPage> {
  String selectedSvg = Assets.icons.otros.biceps.path;
  List<String> svgIcons = [
    Assets.icons.otros.biceps.path,
    Assets.icons.otros.bicicletaDeSpinning.path,
    Assets.icons.otros.estirar.path,
    Assets.icons.otros.gymEquipamiento.path,
    Assets.icons.otros.pantorrillas.path,
    Assets.icons.otros.pierna.path,
    Assets.icons.otros.pesas.path,
    Assets.icons.otros.pesas1.path,
    Assets.icons.otros.manosConOpesas.path,
  ];
  List<int> colors = [
    0xFFF48FB1,
    0xFFB39DDB,
    0xFF90CAF9,
    0xFF80DEEA,
    0xFFA5D6A7,
    0xFFE6EE9C,
    0xFFFFE082,
    0xFFFFAB91,
    0xFFB0BEC5,
    0xFFBCAAA4,
    0xFFFFCC80,
    0xFFFFF59D,
    0xFFC5E1A5,
    0xFF80CBC4,
    0xFF81D4FA,
    0xFFEF9A9A,
    0xFF9FA8DA,
    0xFFCE93D8,
    0xFFD1C4E9,
    0xFFBBDEFB,
    0xFFB2EBF2,
    0xFFAED581,
    0xFFFFF176,
    0xFFCFD8DC,
    0xFFE1BEE7,
    0xFFD7CCC8,
    0xFFFFE0B2,
    0xFFFFF9C4,
    0xFFDCEDC8,
    0xFFC5CAE9,
    0xFFB3E5FC,
    0xFFB2DFDB,
    0xFFFFCDD2,
  ];

  Color selectedColor = Colors.primaries.first.shade200;
  final textController = TextEditingController();
  String? errorMessage;

  void _onSave() async {
    final nombre = textController.text.trim();
    if (nombre.isEmpty) {
      SnackbarHelper().showCustomSnackBar(
        context,
        "El nombre de la rutina es requerido",
        SnackBarType.error,
      );
      return;
    }

    final rutina = Routine(
      fechaCreacion: DateTime.now(),
      name: nombre,
      echo: false,
      color: selectedColor.value,
      description: '',
      cantidadEjercicios: 0,
      imagenDireccion: selectedSvg,
    );

    final routineCubit = BlocProvider.of<RoutineCubit>(context);

    await routineCubit.addRoutine(
      name: rutina.name,
      description: rutina.description ?? '',
      creationDate: rutina.fechaCreacion,
      done: rutina.echo,
      color: rutina.color,
      imagenDireccion: selectedSvg,
    );

    if (!mounted) return;

    if (routineCubit.state is RoutineAddSuccess) {
      final rutinaId = (routineCubit.state as RoutineAddSuccess).rutina.id!;
      //viajar a a esta ruta de gorouter '/rutina/detalle/$rutinaId'

      context.push('/rutina/detalle/$rutinaId');
    }
    if (routineCubit.state is RoutineError) {
      setState(() {
        errorMessage = (routineCubit.state as RoutineError).message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(IconsaxPlusLinear.arrow_left),
          onPressed: () {
            context.push('/');
          },
        ),
        title: const Text('Agregar Rutina'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 300,
                color: selectedColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.icons.logo.path,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                      width: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: textController,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Nombre de la rutina',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                errorMessage ?? '',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'SELECCIONE UN COLOR',
                style: TextStyle(fontSize: 15, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (colors.length / 4).ceil(), // Adjust to show only 3 rows
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  final color = Color(colors[index]);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.color_lens, color: Colors.white),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'SELECCIONE UN ICONO',
                style: TextStyle(fontSize: 15, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: svgIcons.length,
                itemBuilder: (context, index) {
                  final svgPath = svgIcons[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSvg = svgPath;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedSvg == svgPath
                            ? Colors.deepPurple
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          svgPath,
                          width: 40,
                          height: 40,
                          colorFilter: ColorFilter.mode(
                            selectedSvg == svgPath
                                ? Colors.white
                                : Colors.black54,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8870FF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Agregar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
}
