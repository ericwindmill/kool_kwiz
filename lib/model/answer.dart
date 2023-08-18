// Two things are wrong here:
// 1. the code is annoying to update. Any class change to Answer needs to be repeated.
//        We can add multiple-choice multiple-answers as an example.
// 2. The answer should not be responsible for validation logic

sealed class Answer {
  final String correctAnswer;

  Answer({required this.correctAnswer});
}

class OpenTextAnswer extends Answer {
  OpenTextAnswer({required super.correctAnswer});
}

class BooleanAnswer extends Answer {
  BooleanAnswer({required super.correctAnswer});
}

class MultipleChoiceAnswer extends Answer {
  MultipleChoiceAnswer({
    required super.correctAnswer,
    required this.answerOptions,
  });

  final List<String> answerOptions;
}
