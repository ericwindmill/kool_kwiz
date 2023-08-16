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

        // This doesn't seem to validate the Map values types. Is there a way to do that?
        final question = switch (data) {
          {
            'type': 'textQuestion',
            'category': _,
            'answer': _,
            'questionBody': _
          } =>
            TextQuestion(
              id: doc.reference.id,
              questionBody: data['questionBody'] as String,
              category: doc['category'],
            ),
          {
            'type': 'imageQuestion',
            'category': _,
            'answer': _,
            'imageUrl': _,
          } =>
            ImageQuestion(
              id: doc.reference.id,
              imagePath: data['imagePath'] as String,
              category: doc['category'],
            ),
          _ => throw FormatException('Question didn\'t match any patters'),
        };

        final answerJson = data['answer'];
        final answer = switch (answerJson) {
          {
            'type': 'openTextAnswer',
            'correctAnswer': _,
          } =>
            OpenTextAnswer(
                correctAnswer: answerJson['correctAnswer'] as String),
          {
            'type': 'multipleChoiceAnswer',
            'correctAnswer': _,
            'answerOptions': _,
          } =>
            MultipleChoiceAnswer(
              correctAnswer: answerJson['correctAnswer'] as String,
              answerOptions:
                  (answerJson['answerOptions'] as List).cast<String>(),
            ),
          {
            'type': 'booleanAnswer',
            'correctAnswer': _,
          } =>
            BooleanAnswer(correctAnswer: answerJson['correctAnswer'] as String),
          _ => throw FormatException('Answer didn\'t match any patters'),
        };

        questions.add((question, answer));
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
