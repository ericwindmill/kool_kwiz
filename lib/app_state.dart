import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koolkwiz/util/name_generator.dart';

import 'firebase_service.dart';
import 'model/model.dart';

class AppBloc extends ChangeNotifier {
  AppBloc({required this.player, required this.quiz});

  final Player player;
  Stream<Player> playerStream() => FirebaseService.playerStream(
        player,
        quiz.id,
      );

  final Quiz quiz;
  Stream<Quiz> quizStream() => FirebaseService.quizStream(quiz.id);

  Future<void> startQuiz() async {
    FirebaseService.updateQuizStatus(
      quizId: quiz.id,
      status: 'in progress',
    );
  }

  Future<void> validateAnswer(String value) async {
    final isCorrect = value == quiz.currentAnswer.correctAnswer;
    if (isCorrect) {
      player.incrementScore();
      await FirebaseService.updatePlayer(player, quiz.id);
    }
  }

  void nextQuestion() {
    if (quiz.currentQuestionIdx + 1 == quiz.length) {
      completeQuiz();
    } else {
      quiz.currentQuestionIdx++;
    }
    notifyListeners();
  }

  completeQuiz() async {
    await FirebaseService.updateQuizStatus(status: 'complete', quizId: quiz.id);
    // TODO: leaderboard stuff
    notifyListeners();
  }

  resetQuiz() async {
    // TODO: do other shit
    await FirebaseService.updateQuizStatus(quizId: quiz.id, status: 'created');
    notifyListeners();
  }
}
