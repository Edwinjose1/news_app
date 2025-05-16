// lib/presentation/widgets/theme_selector.dart
import 'package:flutter/material.dart';

class ThemeSelector extends StatelessWidget {
  final List<ColorScheme> colorSchemes;
  final Function(int) onColorSchemeSelected;

  const ThemeSelector({
    super.key,
    required this.colorSchemes,
    required this.onColorSchemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colorSchemes.length,
        itemBuilder: (context, index) {
          final colorScheme = colorSchemes[index];
          return GestureDetector(
            onTap: () => onColorSchemeSelected(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary == colorScheme.primary
                      ? Theme.of(context).colorScheme.onPrimary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Theme.of(context).colorScheme.primary == colorScheme.primary
                  ? Icon(
                      Icons.check,
                      color: colorScheme.onPrimary,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}