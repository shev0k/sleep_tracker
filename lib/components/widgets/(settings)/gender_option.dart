// lib/components/widgets/gender_option.dart
import 'package:flutter/material.dart';

class GenderOption extends StatelessWidget {
  final String gender;
  final String selectedGender;
  final ValueChanged<String> onSelected;

  const GenderOption({
    super.key,
    required this.gender,
    required this.selectedGender,
    required this.onSelected,
  });

  void _handleTap() {
    onSelected(gender);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: gender,
              groupValue: selectedGender,
              onChanged: (value) {
                if (value != null) {
                  onSelected(value);
                }
              },
              activeColor: Colors.white,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              gender,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
