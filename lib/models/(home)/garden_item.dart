// lib/models/garden_item.dart

import 'package:flutter/material.dart';
import 'obtained_item.dart';

class GardenItem {
  final ObtainedItem obtainedItem;
  Offset position;
  double rotation;
  static const Size gardenItemSize = Size(50.0, 50.0);

  GardenItem({
    required this.obtainedItem,
    required this.position,
    this.rotation = 0,
  });
}
