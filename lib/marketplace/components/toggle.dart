import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';

class Toggle extends StatefulWidget {
  const Toggle({super.key});

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  String selected = 'Facts & Info';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all<Color>(
                    Marketplace.theme.colorScheme.primary),
                side: MaterialStateProperty.all(
                  BorderSide.lerp(
                      BorderSide(
                        color: Marketplace.theme.colorScheme.onSecondary,
                        width: 2,
                      ),
                      BorderSide(
                        color: Marketplace.theme.colorScheme.onSecondary,
                        width: 2,
                      ),
                      10),
                ),
              ),
              segments: <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'Facts & Info',
                  label: Text(
                    'Facts & Info',
                    style: Marketplace.heading3,
                  ),
                ),
                ButtonSegment<String>(
                  value: 'Trivia',
                  label: Text(
                    'Trivia',
                    style: Marketplace.heading3,
                  ),
                )
              ],
              selected: <String>{selected},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  selected = newSelection.first;
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
