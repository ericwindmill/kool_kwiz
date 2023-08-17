import 'package:flutter/material.dart';

import '../marketplace.dart';

typedef TextChangedCallback = void Function(String?);

class MarketTextField extends StatefulWidget {
  const MarketTextField({super.key, required this.onChange});

  final TextChangedCallback onChange;

  @override
  State<MarketTextField> createState() => _MarketTextFieldState();
}

class _MarketTextFieldState extends State<MarketTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Marketplace.theme.colorScheme.onPrimary,
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChange,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(Marketplace.spacing4),
          fillColor: Marketplace.theme.colorScheme.onPrimary,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Marketplace.theme.colorScheme.onSecondary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
