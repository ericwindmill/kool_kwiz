import 'package:flutter/material.dart';

import '../marketplace.dart';

class MarketCardWithDecoration extends StatelessWidget {
  const MarketCardWithDecoration({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MarketCard(
      child: Padding(
        padding: EdgeInsets.all(Marketplace.spacing4),
        child: Column(
          children: [
            child,
            SizedBox(height: Marketplace.spacing2),
            SeasonsDecoration(
              smallSize: true,
            ),
          ],
        ),
      ),
    );
  }
}

class MarketCard extends StatelessWidget {
  const MarketCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Marketplace.theme.colorScheme.onSecondary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
        color: Marketplace.theme.colorScheme.onPrimary,
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: child,
        ),
      ),
    );
  }
}
