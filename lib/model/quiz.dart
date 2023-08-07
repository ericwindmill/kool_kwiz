import 'package:flutter/cupertino.dart';
import 'package:koolkwiz/model/question.dart';

class Quiz {
  Quiz({
    required this.questions,
    this.length = 10,
  });

  final List<Question> questions;
  final int length;

  List<Question> addQuestions(List<Question> newQuestions) {
    questions.addAll(newQuestions);
    return questions;
  }
}
