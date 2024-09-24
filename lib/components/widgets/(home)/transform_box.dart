// lib/components/widgets/transform_box.dart

import 'package:flutter/material.dart';
import '../../../models/(home)/garden_item.dart';

class TransformBox extends StatelessWidget {
  final Widget child;
  final GardenItem item;

  const TransformBox({
    super.key,
    required this.child,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateZ(item.rotation * 3.1415927 / 180),
      child: child,
    );
  }
}
