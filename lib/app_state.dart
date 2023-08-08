import 'package:flutter/material.dart';

import 'firebase_service.dart';
import 'model/model.dart';

class AppState extends ChangeNotifier {
  AppState({required this.player, required this.quiz});

  final Player player;
  Quiz quiz;

  bool quizComplete = false;
  bool quizReady = true;
  int currentQuestionIdx = 0;
  Question get currentQuestion => quiz.questions[currentQuestionIdx];

  void submitAnswer(String selection) {
    var isCorrect = selection == currentQuestion.correctAnswer;
    if (isCorrect) FirebaseService.incrementScore(player);
  }

  void nextQuestion() {
    if (currentQuestionIdx + 1 == quiz.length) {
      quizComplete = true;
      completeQuiz();
    } else {
      currentQuestionIdx++;
    }
    notifyListeners();
  }

  completeQuiz() async {
    await FirebaseService.completeQuiz(player);
    notifyListeners();
  }

  resetQuiz() async {
    quizReady = false;
    notifyListeners();
    currentQuestionIdx = 0;
    quizComplete = false;
    await FirebaseService.resetCurrentScore(player);
    quiz = await FirebaseService.createQuiz();
    quizReady = true;
    notifyListeners();
  }
}
