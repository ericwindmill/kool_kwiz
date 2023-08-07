import 'package:flutter/material.dart';

import 'firebase_service.dart';
import 'model/model.dart';

class AppState extends ChangeNotifier {
  AppState({required this.player, required this.quiz});

  final Player player;
  final Quiz quiz;

  bool quizComplete = false;
  int currentQuestionIdx = 0;
  Question get currentQuestion => quiz.questions[currentQuestionIdx];

  bool submitAnswer(String selection) {
    var isCorrect = selection == currentQuestion.correctAnswer;
    if (isCorrect) FirebaseService.incrementScore(player);
    return isCorrect;
  }

  void nextQuestion() {
    if (currentQuestionIdx + 1 == quiz.length) {
      quizComplete = true;
    } else {
      currentQuestionIdx++;
    }
    notifyListeners();
  }
}