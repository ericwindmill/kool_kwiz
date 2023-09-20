import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'model.dart';

enum QuizStatus { ready, inProgress, complete }

class Quiz extends ChangeNotifier {
  Quiz({
    required this.id,
    required this.questions,
    this.status = QuizStatus.ready,
    this.currentQuestionIdx = 0,
    this.length = 5,
  });

  /// Firestore id
  final String id;

  /// Either "created", "in progress", or "complete"
  QuizStatus status;

  /// The id of the question that is currently on screen
  int currentQuestionIdx;

  final List<Question> questions;

  /// Programmable. The number of questions of the current quiz
  final int length;

  Question get currentQuestion => questions[currentQuestionIdx];

  Answer get currentAnswer => questions[currentQuestionIdx].answer;

  bool get ready => status == QuizStatus.ready;

  bool get inProgress => status == QuizStatus.inProgress;

  bool get completed => status == QuizStatus.complete;

  factory Quiz.fromFirestore(Map<String, dynamic> json) {
    if (json
        case {
          'id': String id,
          'status': String status,
          'currentQuestionIdx': int currentQuestionIdx,
          'length': int length,
          'questions': List<Object?> questions,
        }) {
      return Quiz(
        id: id,
        status: QuizStatus.values.firstWhere(
          (element) => element.name == status,
        ),
        currentQuestionIdx: currentQuestionIdx,
        length: length,
        questions: questions.map((q) {
          return Question.fromJson(q as Map<String, dynamic>);
        }).toList(),
      );
    } else {
      throw FormatException("Malformed Quiz data from Firestore");
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'status': status.name,
      'currentQuestionIdx': currentQuestionIdx,
      'length': length,
      'questions': questions.map((q) => Question.toJson(q)),
    };
  }
}
