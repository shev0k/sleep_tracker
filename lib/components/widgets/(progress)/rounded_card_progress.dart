import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Border? border;

  const RoundedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: border,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
