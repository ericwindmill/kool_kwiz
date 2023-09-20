import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'marketplace/components/colored_dot_loading_indicator.dart';
import 'marketplace/marketplace.dart';
import 'model/model.dart';
import 'views/quiz_screen.dart';
import 'views/start_quiz_screen.dart';

// This Widget is basically the router.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppBloc>();
    final player = context.watch<Player>();
    final quiz = context.watch<Quiz>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Marketplace.appBackground,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Player: ${player.name ?? 'loading'} ',
              style: Marketplace.label,
            ),
            Text(
              'Score: ${player.currentScore ?? 'loading'}',
              style: Marketplace.label,
            )
          ],
        ),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            // initial welcome screen
            return switch (quiz.status) {
              QuizStatus.ready => StartQuizScreen(
                  onStartQuiz: () => state.startQuiz(),
                ),
              QuizStatus.inProgress => QuizScreen(),
              QuizStatus.complete => Center(
                  child: Text('AppWidget.Quiz Status == Complete'),
                ) // TODO
            };
          },
        ),
      ),
    );
  }
}
