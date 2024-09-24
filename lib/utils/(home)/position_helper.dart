// lib/utils/position_helper.dart

import 'package:flutter/material.dart';
import '../../../models/(home)/garden_item.dart';

class PositionHelper {
  // clamps the position within the garden
  static Offset clampPositionWithinGarden(
      Offset position, Size itemSize, RenderBox gardenBox) {
    final Size gardenSize = gardenBox.size;

    double clampedX =
        position.dx.clamp(0.0, gardenSize.width - itemSize.width);
    double clampedY =
        position.dy.clamp(0.0, gardenSize.height - itemSize.height);

    return Offset(clampedX, clampedY);
  }

  // calculate control card position relative to a garden item
  static Offset calculateControlCardPosition(
      GardenItem item, Size controlCardSize, RenderBox gardenBox) {
    const double baseIconSize = 50.0;
    const double controlPadding = 10.0;

    // calculate center of the item
    double itemCenterX = item.position.dx + baseIconSize / 2;
    double offsetX = itemCenterX - controlCardSize.width / 2;

    // position control card slightly below the item
    double offsetY = item.position.dy + baseIconSize + controlPadding;

    // if control card goes beyond the bottom of garden, place it above the item
    if (offsetY + controlCardSize.height > gardenBox.size.height) {
      offsetY = item.position.dy - controlCardSize.height - controlPadding - 15;
    }

    // clamp x and y positions to stay within garden
    offsetX = offsetX.clamp(0.0, gardenBox.size.width - controlCardSize.width);
    offsetY = offsetY.clamp(0.0, gardenBox.size.height - controlCardSize.height);

    return Offset(offsetX, offsetY);
  }
}
