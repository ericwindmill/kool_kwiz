import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'marketplace/marketplace.dart';
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
  bool _hasStartedQuiz = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Marketplace.appBackground,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Player: ${state.player.name}',
              style: Marketplace.label,
            ),
            Text('Score: ${state.player.currentScore}')
          ],
        ),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            // initial welcome screen
            if (!_hasStartedQuiz) {
              return StartQuizScreen(
                onStartQuiz: () {
                  setState(() {
                    _hasStartedQuiz = true;
                  });
                },
              );
            }

            // Show the Leaderboard screen
            if (state.quiz.status == 'complete') {
              // todo: return ResultsScreen();
              // return LeaderboardScreen(onReset: () {
              //   state.resetQuiz();
              //   setState(() {
              //     _hasStartedQuiz = false;
              //   });
              // });
            }

            return QuizScreen();
          },
        ),
      ),
    );
  }
}
