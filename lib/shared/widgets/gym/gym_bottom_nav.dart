import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

class GymNavItem {
  final IconData icon;
  final String label;
  const GymNavItem(this.icon, this.label);
}

/// Barra de navegación inferior con indicador de punto. Reemplaza el
/// `BottomNavigationBar` de ejemplo (`BottomNavigationBarExampleApp`).
class GymBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<GymNavItem> items;

  const GymBottomNav({
    super.key,
    required this.index,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.line)),
      ),
      padding: EdgeInsets.only(
        top: 6,
        bottom: MediaQuery.of(context).padding.bottom + 8,
        left: 6,
        right: 6,
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final active = index == i;
          final color = active ? c.brand : c.faint;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(items[i].icon, size: 24, color: color),
                  const SizedBox(height: 3),
                  Text(items[i].label,
                      style: GymType.micro.copyWith(color: color)),
                  const SizedBox(height: 4),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: active ? c.brand : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
