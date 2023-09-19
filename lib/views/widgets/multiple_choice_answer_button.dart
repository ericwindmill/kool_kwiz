import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/theme.dart';

import '../../model/question.dart';

class MultipleChoiceAnswerButton extends StatefulWidget {
  MultipleChoiceAnswerButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.isActive,
  });

  final Function onPressed;
  final String text;
  final bool isSelected;
  final bool isCorrectAnswer;
  final bool isActive;

  @override
  State<MultipleChoiceAnswerButton> createState() => _MultipleChoiceAnswerButtonState();
}

class _MultipleChoiceAnswerButtonState extends State<MultipleChoiceAnswerButton> {
  bool isPressed = false;
  bool isHovered = false;
  final Color pressedColor = Marketplace.theme.colorScheme.primary;
  final Color hoveredColor = Marketplace.theme.colorScheme.primary.withOpacity(.5);
  final Color initialColor = Marketplace.theme.colorScheme.onPrimary;
  final Color inactiveColor = Marketplace.inactiveButton;
  final Color correctAnswerColor = Marketplace.correctChoiceColor;
  final Color incorrectAnswerColor = Marketplace.wrongChoiceColor;
  late bool isActive;
  late bool isCorrect;
  late bool isSelected;

  @override
  initState() {
    isActive = widget.isActive;
    isCorrect = widget.isCorrectAnswer;
    isSelected = widget.isSelected;
    super.initState();
  }

  tapDown(TapDownDetails e) {
    setState(() {
      isPressed = true;
    });
  }

  tapUp(TapUpDetails e) {
    setState(() {
      isPressed = false;
      if (isActive) widget.onPressed();
    });
  }

  onEnter(_) {
    setState(() {
      isHovered = true;
    });
  }

  onExit(_) {
    setState(() {
      isHovered = false;
    });
  }

  Color get buttonColor {
    isActive = widget.isActive;
    isCorrect = widget.isCorrectAnswer;
    isSelected = widget.isSelected;
    final record = (isActive, isPressed, isHovered, isSelected, isCorrect);
    return switch (record) {
      (true, true, _, _, _) => pressedColor,
      (true, _, true, _, _) => hoveredColor,
      (true, false, _, _, _) => initialColor,
      (false, _, _, true, false) => incorrectAnswerColor,
      (false, _, _, _, true) => correctAnswerColor,
      (false, _, _, _, _) => inactiveColor,
    };
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
