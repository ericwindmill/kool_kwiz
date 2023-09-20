import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/components/colored_dot_loading_indicator.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';

class StartQuizScreen extends StatelessWidget {
  final VoidCallback onStartQuiz;
  const StartQuizScreen({super.key, required this.onStartQuiz});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<Quiz>();

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
        if (quiz.status == QuizStatus.ready)
          MarketButton(
            onPressed: onStartQuiz,
            text: 'Start Quiz!',
          ),
        if (quiz.status != QuizStatus.ready) DotLoadingIndicator(),
      ],
    );
  }
}
