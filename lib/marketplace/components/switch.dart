import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';

class MarketSwitch extends StatefulWidget {
  const MarketSwitch({super.key});

  @override
  State<MarketSwitch> createState() => _MarketSwitchState();
}

class _MarketSwitchState extends State<MarketSwitch> {
  bool val = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 36,
        width: 48,
        child: GestureDetector(
          onTap: () {
            setState(() {
              val = !val;
            });
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 48,
                  height: 14,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color: val
                        ? Marketplace.theme.colorScheme.scrim
                        : Marketplace.theme.colorScheme.shadow,
                  ),
                ),
              ),
              AnimatedAlign(
                alignment: val ? Alignment.centerRight : Alignment.centerLeft,
                duration: Duration(milliseconds: 100),
                child: Circle(
                  size: 24,
                  color: Marketplace.theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
