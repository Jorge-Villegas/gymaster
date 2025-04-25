import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/setting/presentation/cubit/setting_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubit/setting_state.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocProvider.of<SettingCubit>(context)..loadSettings(),
      child: Scaffold(
        body: Column(
          children: [
            const Expanded(flex: 2, child: _TopPortion()),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Jorge Villegas",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: const Icon(IconsaxPlusLinear.user),
                            title: const Text('Manejo de suscripción'),
                            onTap: () {
                              // Implement subscription management logic here
                            },
                          ),
                          BlocBuilder<SettingCubit, SettingState>(
                            builder: (context, state) {
                              if (state is SettingLoaded) {
                                return ListTile(
                                  leading: const Icon(IconsaxPlusLinear.moon),
                                  title: const Text('Tema de la aplicación'),
                                  subtitle: Text(state.theme),
                                  onTap: () => _showThemeBottomSheet(context),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          BlocBuilder<SettingCubit, SettingState>(
                            builder: (context, state) {
                              if (state is SettingLoaded) {
                                return ListTile(
                                  leading: const Icon(
                                    IconsaxPlusLinear.notification,
                                  ),
                                  title: const Text('Notificaciones'),
                                  trailing: CupertinoSwitch(
                                    value: state.isNotificationEnabled,
                                    onChanged: (value) {
                                      context
                                          .read<SettingCubit>()
                                          .toggleNotification(value);
                                    },
                                    activeTrackColor: Theme.of(context)
                                        .primaryColor, // Opcional: para que coincida con el tema
                                  ),
                                  onTap: () {
                                    // Permite activar/desactivar tocando toda la fila
                                    context
                                        .read<SettingCubit>()
                                        .toggleNotification(
                                            !state.isNotificationEnabled);
                                  },
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Preferencias',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(IconsaxPlusLinear.ruler),
                            title: const Text('Entrenamientos'),
                            onTap: () {
                              // Implement training preferences logic here
                            },
                          ),
                          ListTile(
                            leading: const Icon(IconsaxPlusLinear.ruler),
                            title: const Text('Privacidad y redes sociales'),
                            onTap: () {
                              // Implement privacy and social networks logic here
                            },
                          ),
                          ListTile(
                            leading: const Icon(IconsaxPlusLinear.ruler),
                            title: const Text('Preferencias de unidades'),
                            onTap: () => _showUnitOptionsBottomSheet(context),
                          ),
                          BlocBuilder<SettingCubit, SettingState>(
                            builder: (context, state) {
                              if (state is SettingLoaded) {
                                return ListTile(
                                  leading: const Icon(IconsaxPlusLinear.global),
                                  title: const Text('Idioma de la aplicación'),
                                  subtitle: Text(state.language),
                                  onTap: () =>
                                      _showLanguageBottomSheet(context),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Ayuda',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(IconsaxPlusLinear.ruler),
                            title: const Text('Preguntas frecuentes'),
                            onTap: () {
                              // Implement FAQ logic here
                            },
                          ),
                          ListTile(
                            leading: const Icon(IconsaxPlusLinear.ruler),
                            title: const Text('Contactos'),
                            onTap: () {
                              // Implement contacts logic here
                            },
                          ),
                          ListTile(
                            leading: const Icon(IconsaxPlusLinear.ruler),
                            title: const Text('Acerca de GymMaster'),
                            onTap: () {
                              // Implement about GymMaster logic here
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnitOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            if (state is SettingLoaded) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preferencias de Unidades',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ToggleOption(
                          title: 'Peso',
                          options: const ['kg', 'lb'],
                          onSelected: (index) {
                            context.read<SettingCubit>().setWeightUnit(
                                  index == 0 ? 'kg' : 'lb',
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        ToggleOption(
                          title: 'Longitud',
                          options: const ['cm', 'in'],
                          onSelected: (index) {
                            context.read<SettingCubit>().setLengthUnit(
                                  index == 0 ? 'cm' : 'in',
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        ToggleOption(
                          title: 'Hora',
                          options: const ['24h', '12h'],
                          onSelected: (index) {
                            context.read<SettingCubit>().setTimeFormat(
                                  index == 0 ? '24h' : '12h',
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        ToggleOption(
                          title: 'Fecha',
                          options: const ['31.01', '01/31'],
                          onSelected: (index) {
                            context.read<SettingCubit>().setDateFormat(
                                  index == 0 ? '31.01' : '01/31',
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        ToggleOption(
                          title: 'Calorías',
                          options: const ['kcal', 'kj'],
                          onSelected: (index) {
                            context.read<SettingCubit>().setCalories(
                                  index == 0 ? 'kcal' : 'kj',
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            if (state is SettingLoaded) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seleccione su idioma preferido:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.languages.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(state.languages[index]),
                          value: state.languages[index],
                          groupValue: state.language,
                          onChanged: (value) {
                            context.read<SettingCubit>().updateLanguage(value!);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            if (state is SettingLoaded) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seleccione su tema preferido:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        RadioListTile<String>(
                          title: const Text('Claro'),
                          value: 'Claro',
                          groupValue: state.theme,
                          onChanged: (value) {
                            context.read<SettingCubit>().setTheme(value!);
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Oscuro'),
                          value: 'Oscuro',
                          groupValue: state.theme,
                          onChanged: (value) {
                            context.read<SettingCubit>().setTheme(value!);
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Sistema'),
                          value: 'Sistema',
                          groupValue: state.theme,
                          onChanged: (value) {
                            context.read<SettingCubit>().setTheme(value!);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://media.istockphoto.com/id/1090878494/es/foto/retrato-de-joven-sonriente-a-hombre-guapo-en-camiseta-polo-azul-aislado-sobre-fondo-gris-de.jpg?s=612x612&w=0&k=20&c=dHFsDEJSZ1kuSO4wTDAEaGOJEF-HuToZ6Gt-E2odc6U=',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 40,
    );
    path.quadraticBezierTo(
      3 / 4 * size.width,
      size.height - 80,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ToggleOption extends StatefulWidget {
  final String title;
  final List<String> options;
  final ValueChanged<int> onSelected;

  const ToggleOption({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  ToggleOptionState createState() => ToggleOptionState();
}

class ToggleOptionState extends State<ToggleOption> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.bodyLarge),
          Row(
            children: widget.options.asMap().entries.map((entry) {
              int index = entry.key;
              String value = entry.value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onSelected(index);
                },
                child: Container(
                  width: 75,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
