import 'model.dart';

class Quiz {
  Quiz({
    required this.questionList,
    this.length = 5,
  });

  final List<(Question, Answer)> questionList;
  final int length;

  List<(Question, Answer)> addQuestions(List<(Question, Answer)> newQuestions) {
    questionList.addAll(newQuestions);
    return questionList;
  }
}
