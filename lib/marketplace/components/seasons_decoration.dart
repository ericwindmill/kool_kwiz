import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';

class SeasonsDecoration extends StatelessWidget {
  const SeasonsDecoration({this.smallSize = false, super.key});

  final bool smallSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Circle(
          color: Marketplace.theme.colorScheme.tertiary,
          size: smallSize ? small : medium,
        ),
        SizedBox(width: 8),
        Circle(
          color: Marketplace.theme.colorScheme.secondary,
          size: smallSize ? small : medium,
        ),
        SizedBox(width: 8),
        Circle(
          color: Marketplace.theme.colorScheme.scrim,
          size: smallSize ? small : medium,
        ),
        SizedBox(width: 8),
        Circle(
          color: Marketplace.theme.colorScheme.primary,
          size: smallSize ? small : medium,
        ),
      ],
    );
  }
}
