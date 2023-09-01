import 'package:flutter/material.dart';

import 'firebase_service.dart';
import 'model/model.dart';

class AppState extends ChangeNotifier {
  AppState({required this.player, required this.quiz});

  final Player player;
  Quiz quiz;
  bool quizComplete = false;
  bool quizReady = true;
  int _currentQuestionIdx = 0;
  Question get currentQuestion => quiz.questionList[_currentQuestionIdx];
  Answer get currentAnswer => quiz.questionList[_currentQuestionIdx].answer;

  bool validateAnswer(String value) {
    final isCorrect = value == currentAnswer.correctAnswer;
    if (isCorrect) FirebaseService.incrementScore(player);
    return isCorrect;
  }

  void nextQuestion() {
    if (_currentQuestionIdx + 1 == quiz.length) {
      quizComplete = true;
      completeQuiz();
    } else {
      _currentQuestionIdx++;
    }
    notifyListeners();
  }

  completeQuiz() async {
    player.updateLeaderboardStats();
    await FirebaseService.updateUserLeaderboardStats(player);
    notifyListeners();
  }

  resetQuiz() async {
    quizReady = false;
    notifyListeners();
    _currentQuestionIdx = 0;
    quizComplete = false;
    await FirebaseService.resetCurrentScore(player);
    quiz = await FirebaseService.createQuiz();
    quizReady = true;
    notifyListeners();
  }
}
