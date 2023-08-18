import 'package:koolkwiz/model/model.dart';

@Deprecated('Use records!')
class QuestionAndAnswer {
  QuestionAndAnswer({
    required this.question,
    required this.answer,
  });

  final Question question;
  final Answer answer;
}
