import 'package:flutter/material.dart';
import 'package:gymaster/shared/models/elemento_menu_modelo.dart';
import 'package:gymaster/shared/widgets/fila_menu_lateral.dart';

class SeccionBotonesMenu extends StatelessWidget {
  const SeccionBotonesMenu({
    super.key,
    required this.titulo,
    required this.elementosMenu,
    this.menuSeleccionado = "",
    this.alPresionarMenu,
  });

  final String titulo;
  final String menuSeleccionado;
  final List<ElementoMenuModelo> elementosMenu;
  final Function(ElementoMenuModelo menu)? alPresionarMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 8),
          child: Text(
            titulo,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Lista de elementos del menú - estilo flutter-samples
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var elemento in elementosMenu) ...[
                Divider(
                  color: Colors.white.withValues(alpha: 0.1),
                  thickness: 1,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                FilaMenuLateral(
                  elementoMenu: elemento,
                  menuSeleccionado: menuSeleccionado,
                  alPresionarMenu: () {
                    alPresionarMenu?.call(elemento);
                  },
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
