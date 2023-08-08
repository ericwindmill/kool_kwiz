import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/components/colored_dot_loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.loadingMessage});

  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DotLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
