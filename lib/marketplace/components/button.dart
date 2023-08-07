import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';

class MarketButton extends StatefulWidget {
  MarketButton(
      {required this.onPressed, super.key, required this.text, this.color});

  final Function onPressed;
  final String text;
  final Color? color;

  @override
  State<MarketButton> createState() => _MarketButtonState();
}

class _MarketButtonState extends State<MarketButton> {
  bool pressed = false;
  bool hovered = false;
  final Color pressedColor = Marketplace.theme.colorScheme.primary;
  final Color hoveredColor =
      Marketplace.theme.colorScheme.primary.withOpacity(.5);
  final Color initialColor = Marketplace.theme.colorScheme.onPrimary;

  tapDown(TapDownDetails e) {
    setState(() {
      pressed = true;
    });
  }

  tapUp(TapUpDetails e) {
    setState(() {
      pressed = false;
      widget.onPressed();
    });
  }

  onEnter(_) {
    setState(() {
      hovered = true;
    });
  }

  onExit(_) {
    setState(() {
      hovered = false;
    });
  }

  Color get buttonColor {
    if (widget.color != null) return widget.color!;
    if (hovered && !pressed) return hoveredColor;
    if (pressed) return pressedColor;
    return initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      child: GestureDetector(
        onTapDown: tapDown,
        onTapUp: tapUp,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(
              color: Marketplace.theme.colorScheme.onSecondary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 72),
            child: Text(
              textAlign: TextAlign.center,
              style: Marketplace.label,
              widget.text,
            ),
          ),
        ),
      ),
    );
  }
}
