import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class BarraNavegacion extends StatefulWidget {
  final Function currentIndex;

  const BarraNavegacion({
    super.key,
    required this.currentIndex,
  });

  @override
  State<BarraNavegacion> createState() => _BarraNavegacionState();
}

class _BarraNavegacionState extends State<BarraNavegacion> {
  int _index = 0;

  static const double selectedHeight = 50.0;
  static const double unselectedHeight = 40.0;

  static const double selectedPaddingHorizontal = 16.0;
  static const double unselectedPaddingHorizontal = 8.0;

  static const double selectedPaddingVertical = 8.0;
  static const double unselectedPaddingVertical = 4.0;

  static const double borderRadius = 30.0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).primaryColor,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      onTap: (index) {
        setState(() {
          _index = index;
          widget.currentIndex(index);
        });
      },
      currentIndex: _index,
      items: <BottomNavigationBarItem>[
        _buildBottomNavigationBarItem(
          icon: IconsaxPlusLinear.home_1,
          label: 'Inicio',
          isSelected: _index == 0,
          iconSelected: IconsaxPlusBold.home_1,
          color: Colors.blue,
        ),
        _buildBottomNavigationBarItem(
          icon: IconsaxPlusLinear.activity,
          label: 'Rutinas finalizadas',
          isSelected: _index == 1,
          iconSelected: IconsaxPlusBold.activity,
          color: Colors.green,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.add,
          label: 'Prueba',
          isSelected: _index == 2,
          iconSelected: Icons.add,
          color: Colors.red,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.list,
          label: 'Data',
          isSelected: _index == 3,
          iconSelected: IconsaxPlusBold.like_shapes,
          color: Colors.orange,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required IconData iconSelected,
    required String label,
    required bool isSelected,
    required Color color,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSelected
              ? selectedPaddingHorizontal
              : unselectedPaddingHorizontal,
          vertical:
              isSelected ? selectedPaddingVertical : unselectedPaddingVertical,
        ),
        height: isSelected ? selectedHeight : unselectedHeight,
        decoration: isSelected
            ? BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? iconSelected : icon,
                color: isSelected ? color : null),
            if (isSelected)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      label: '',
    );
  }
}
