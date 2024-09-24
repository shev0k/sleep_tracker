// lib/components/widgets/continue_button.dart

import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ContinueButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          textStyle: const TextStyle(fontSize: 18),
        ),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Continue"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}
