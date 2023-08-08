import 'package:flutter/material.dart';
import 'package:koolkwiz/screens/leaderboard_screen.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'marketplace/marketplace.dart';
import 'model/model.dart';
import 'screens/quiz_screen.dart';
import 'screens/start_quiz_screen.dart';

// This Widget is basically the router.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _hasStartedQuiz = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final player = context.watch<Player>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Marketplace.appBackground,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Player: ${player.name}',
              style: Marketplace.label,
            ),
            Text('Score: ${player.currentScore}')
          ],
        ),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            // initial welcome screen
            if (!_hasStartedQuiz) {
              return StartQuizScreen(
                onStartQuiz: () => setState(() {
                  _hasStartedQuiz = true;
                }),
              );
            }

            // Show the Leaderboard screen
            if (state.quizComplete) {
              return LeaderboardScreen(onReset: () {
                state.resetQuiz();
                setState(() {
                  _hasStartedQuiz = false;
                });
              });
            }

            return QuizScreen();
          },
        ),
      ),
    );
  }
}
