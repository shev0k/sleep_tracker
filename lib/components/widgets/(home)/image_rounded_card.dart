// lib/components/widgets/image_rounded_card.dart

import 'package:flutter/material.dart';

class ImageRoundedCard extends StatelessWidget {
  final String imagePath;
  final Widget child;

  const ImageRoundedCard({
    super.key,
    required this.imagePath,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}
