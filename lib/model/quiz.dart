import 'model.dart';

class Quiz {
  Quiz({
    required this.questionList,
    this.length = 5,
  });

  final List<Question> questionList;
  final int length;

  List<Question> addQuestions(List<Question> newQuestions) {
    questionList.addAll(newQuestions);
    return questionList;
  }
}
