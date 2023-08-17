import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/model.dart';

class _Temp {
  static Future<Quiz> createQuiz() async {
    final questions = <(Question, Answer)>[];
    return FirebaseFirestore.instance
        .collection('questions')
        .get()
        .then((QuerySnapshot value) {
      for (var doc in value.docs) {
        final data = doc.data();
        if (data is Map<String, Object?> &&
            data.containsKey('type') &&
            data.containsKey('category') &&
            data['answer'] is Map<String, Object?>) {
          late Question question;
          final questionType = data['type'];

          // Validate that the question type is correct
          if (data['type'] != 'textQuestion' &&
              data['type'] != 'imageQuestion') {
            throw FormatException(
                'Question type must be imageQuestion or textQuestion. Got ${data['type']}');
          }

          // Validate that the question types have the correct properties
          if (data['type'] == 'textQuestion' &&
              !data.containsKey('questionBody')) {
            throw FormatException(
                'Questions of type textQuestion must contain questionBody');
          } else if (data['type'] == 'imageQuestion' &&
              !data.containsKey('imagePath')) {
            throw FormatException(
                'Question of type imageQuestion must contain an imagePath');
          }

          // Build Question
          if (questionType == 'textQuestion') {
            question = TextQuestion(
              id: doc.reference.id,
              questionBody: data['questionBody'] as String,
              category: doc['category'],
            );
          } else if (questionType == 'imageQuestion') {
            if (data['imagePath'] is! String) {
              throw FormatException(
                  'imagePath must be exist and must be a String!');
            }

            question = ImageQuestion(
              id: doc.reference.id,
              imagePath: data['imagePath'] as String,
              category: doc['category'],
            );
          }

          // Validate that answer data exists
          final answerJson = data['answer'];
          if (answerJson is! Map<String, dynamic>) {
            throw FormatException(
                'Answer data must exist, and must be a Map. Got $answerJson');
          }

          // Build Answer
          final answerData = data['answer'] as Map<String, Object?>;
          final answerType = answerData['type'];
          late Answer answer;
          if (answerType != 'openTextAnswer' &&
              answerType != 'multipleChoiceAnswer' &&
              answerType != 'booleanAnswer') {
            throw FormatException(
                'Answer type must be one of: openTextAnswer, multipleChoiceAnswer, booleanAnswer');
          }

          if (!answerData.containsKey('correctAnswer')) {
            throw FormatException('Answer.correctAnswer must exist.');
          }

          // create OpenTextAnswer
          if (answerType == 'openTextAnswer') {
            if (answerData['correctAnswer'] is! String) {
              throw FormatException(
                  'For openTextAnswers, the answerData must be a String. Got ${answerData['correctAnswer']}');
            }
            answer = OpenTextAnswer(
                correctAnswer: answerData['correctAnswer'] as String);

            // Create multipleChoiceAnswer
          } else if (answerType == 'multipleChoiceAnswer') {
            if (!answerData.containsKey('answerOptions') ||
                answerData['answerOptions'] is! List) {
              throw FormatException(
                  'answerOptions must exist in a multipleChoiceAnswer, and it must be a List of Strings. Got ${answerData['answerOptions']}, type: ${answerData['answerOptions'].runtimeType}');
            }
            if (answerData['correctAnswer'] is! String) {
              throw FormatException(
                  'For multipleChoiceAnswers, the answerData must be a String. Got ${answerData['correctAnswer']}');
            }
            final answerOptionsData =
                (answerData['answerOptions'] as List).cast<String>();

            answer = MultipleChoiceAnswer(
              correctAnswer: answerData['correctAnswer'] as String,
              answerOptions: answerOptionsData,
            );
          } else if (answerType == 'booleanAnswer') {
            if (answerData['correctAnswer'] is! bool) {
              throw FormatException(
                  'For booleanAnswers, the answerData must be a boolean. Got ${answerData['correctAnswer']}');
            }
            answer = BooleanAnswer(
                correctAnswer: answerData['correctAnswer'] as String);
          }
          questions.add((question, answer));
        }
      }

      final quiz = Quiz(questionList: []);
      // Make sure every quiz contains a random assortment of 10 questions.
      questions.shuffle();
      final questionsForQuizLength = questions.take(quiz.length).toList();
      quiz.addQuestions(questionsForQuizLength);
      return quiz;
    });
  }
}
