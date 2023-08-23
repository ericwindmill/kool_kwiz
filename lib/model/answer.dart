sealed class Answer {
  final String correctAnswer;

  Answer({required this.correctAnswer});

  static Answer fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'type': 'openTextAnswer',
        'correctAnswer': _,
      } =>
        OpenTextAnswer(
          correctAnswer: json['correctAnswer'] as String,
        ),
      {
        'type': 'multipleChoiceAnswer',
        'correctAnswer': _,
        'answerOptions': _,
      } =>
        MultipleChoiceAnswer(
          correctAnswer: json['correctAnswer'] as String,
          answerOptions: (json['answerOptions'] as List).cast<String>(),
        ),
      {
        'type': 'booleanAnswer',
        'correctAnswer': _,
      } =>
        BooleanAnswer(correctAnswer: json['correctAnswer'] as String),
      _ => throw FormatException("Answer didn't match any patters"),
    };
  }

  static Map<String, dynamic> toJson(Answer answer) {
    return switch (answer) {
      OpenTextAnswer _ => {},
      BooleanAnswer _ => {},
      MultipleChoiceAnswer _ => {}
    };
  }
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
