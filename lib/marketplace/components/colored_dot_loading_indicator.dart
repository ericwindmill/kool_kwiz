import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../marketplace.dart';

class DotLoadingIndicator extends StatefulWidget {
  const DotLoadingIndicator({super.key});

  @override
  State<DotLoadingIndicator> createState() => _DotLoadingIndicatorState();
}

class _DotLoadingIndicatorState extends State<DotLoadingIndicator>
    with TickerProviderStateMixin {
  final List<AnimationController> controllers = [];

  @override
  void initState() {
    controllers.addAll(
      [
        AnimationController(vsync: this),
        AnimationController(vsync: this),
        AnimationController(vsync: this),
        AnimationController(vsync: this),
      ],
    );
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(Marketplace.spacing8),
          child:
              Circle(size: small, color: Theme.of(context).colorScheme.primary),
        )
            .animate(
              delay: 0.ms,
              controller: controllers[0],
              onComplete: (controller) {
                controller.value = 0;
                controllers[1].forward();
              },
            )
            .move(duration: 300.ms, begin: Offset(0, 0), end: Offset(0, -20))
            .then()
            .move(duration: 300.ms, begin: Offset(0, -20), end: Offset(0, 0)),
        Padding(
          padding: EdgeInsets.all(Marketplace.spacing8),
          child: Circle(
              size: small, color: Theme.of(context).colorScheme.secondary),
        )
            .animate(
              controller: controllers[1],
              autoPlay: false,
              onComplete: (controller) {
                controller.value = 0;
                controllers[2].forward();
              },
            )
            .move(duration: 300.ms, begin: Offset(0, 0), end: Offset(0, -20))
            .then()
            .move(duration: 300.ms, begin: Offset(0, -20), end: Offset(0, 0)),
        Padding(
          padding: EdgeInsets.all(Marketplace.spacing8),
          child: Circle(
              size: small, color: Theme.of(context).colorScheme.tertiary),
        )
            .animate(
              controller: controllers[2],
              autoPlay: false,
              onComplete: (controller) {
                controller.value = 0;
                controllers[3].forward();
              },
            )
            .move(duration: 300.ms, begin: Offset(0, 0), end: Offset(0, -20))
            .then()
            .move(duration: 300.ms, begin: Offset(0, -20), end: Offset(0, 0)),
        Padding(
          padding: EdgeInsets.all(Marketplace.spacing8),
          child:
              Circle(size: small, color: Theme.of(context).colorScheme.scrim),
        )
            .animate(
              controller: controllers[3],
              autoPlay: false,
              onComplete: (controller) {
                controller.value = 0;
                controllers[0].forward();
              },
            )
            .move(duration: 300.ms, begin: Offset(0, 0), end: Offset(0, -20))
            .then()
            .move(duration: 300.ms, begin: Offset(0, -20), end: Offset(0, 0))
      ],
    );
  }
}
