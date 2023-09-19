import 'package:flutter/foundation.dart';
import 'model.dart';

class Quiz extends ChangeNotifier {
  Quiz({
    required this.id,
    required this.questions,
    this.status = "created",
    this.currentQuestionIdx = 0,
    this.length = 5,
  });

  /// Firestore id
  final String id;

  /// Either "created", "in progress", or "complete"
  String status;

  /// The id of the question that is currently on screen
  int currentQuestionIdx;

  final List<Question> questions;

  /// Programmable. The number of questions of the current quiz
  final int length;

  Question get currentQuestion => questions[currentQuestionIdx];

  Answer get currentAnswer => questions[currentQuestionIdx].answer;

  bool get ready => status == 'created';

  bool get inProgress => status == 'in progress';

  bool get completed => status == 'completed';

  factory Quiz.fromFirestore(Map<String, dynamic> json) {
    if (json
        case {
          'id': String id,
          'status': String status,
          'currentQuestionIdx': int currentQuestionIdx,
          'length': int length,
          'questions': Iterable<Map<String, dynamic>> questions,
        }) {
      return Quiz(
        id: id,
        status: status,
        currentQuestionIdx: currentQuestionIdx,
        length: length,
        questions: questions.map((q) => Question.fromJson(q)).toList(),
      );
    } else {
      throw FormatException("Malformed Quiz data from Firestore");
    }
  }
}
