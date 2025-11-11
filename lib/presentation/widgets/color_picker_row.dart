import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ColorPickerRow extends StatelessWidget {
  final int selectedColorValue;
  final ValueChanged<int> onChanged;
  final List<Color> palette;

  const ColorPickerRow({
    super.key,
    required this.selectedColorValue,
    required this.onChanged,
    this.palette = AppColors.noteColors, // default
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children:
          palette.map((c) {
            final isSelected = c.value == selectedColorValue;
            return InkWell(
              onTap: () => onChanged(c.value),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black54 : Colors.black12,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: isSelected ? const Icon(Icons.check, size: 16) : null,
              ),
            );
          }).toList(),
    );
  }
}
