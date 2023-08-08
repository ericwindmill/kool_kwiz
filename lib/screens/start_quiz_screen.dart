import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class StartQuizScreen extends StatelessWidget {
  final VoidCallback onStartQuiz;
  const StartQuizScreen({super.key, required this.onStartQuiz});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Kool Kwiz',
          style: Marketplace.title,
        ),
        SizedBox(height: Marketplace.spacing4),
        ShowCircles(),
        SizedBox(height: Marketplace.spacing3),
        if (state.quizReady)
          MarketButton(
            onPressed: onStartQuiz,
            text: 'Start Quiz!',
          )
      ],
    );
  }
}
