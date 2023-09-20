import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firebase_service.dart';
import 'model/model.dart';

class AppBloc extends ChangeNotifier {
  AppBloc({required this.player, required this.quiz});

  final Player player;
  final Quiz quiz;

  Future<void> startQuiz() async {
    FirebaseService.updateQuizStatus(
      quizId: quiz.id,
      status: QuizStatus.inProgress,
    );
  }

  Future<void> validateAnswer(String value) async {
    final isCorrect = value == quiz.currentAnswer.correctAnswer;
    if (isCorrect) {
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
    await FirebaseService.updateQuizStatus(
      status: QuizStatus.complete,
      quizId: quiz.id,
    );
    // TODO: leaderboard stuff
    notifyListeners();
  }

  resetQuiz() async {
    // TODO: do other shit
    await FirebaseService.updateQuizStatus(
      quizId: quiz.id,
      status: QuizStatus.ready,
    );
    notifyListeners();
  }
}
