import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koolkwiz/util/name_generator.dart';

import 'model/model.dart';

// TODO: Remove file before the preso

Future<Quiz> _createQuizOld() async {
  final questions = <Question>[];
  return FirebaseFirestore.instance
      .collection('questions')
      .get()
      .then((QuerySnapshot value) {
    for (var doc in value.docs) {
      try {
        final data = doc.data();
        final validStructure = data is Map<String, Object?> &&
            data.containsKey('type') &&
            data.containsKey('id') &&
            data.containsKey('category') &&
            data['answer'] is Map<String, Object?>;
        if (!validStructure) {
          throw FormatException(
              'Malformed question data coming from Firestore');
        }
        // Build Answer
        final answerData = data['answer'] as Map<String, Object?>;
        final answerType = answerData['type'];

        if (answerType != 'openTextAnswer' &&
            answerType != 'multipleChoiceAnswer' &&
            answerType != 'booleanAnswer') {
          throw FormatException('Answer type not recognized');
        }
        if (!answerData.containsKey('correctAnswer') ||
            answerData['correctAnswer'] is! String) {
          throw FormatException(
              'Answer.correctAnswer must exist, and must be a String. Got ${answerData['correctAnswer']}');
        }

        if (answerType == 'multipleChoiceAnswer' &&
            answerData['answerOptions'] is! List<String>) {
          throw FormatException(
              'Answer.correctAnswer must exist, and must be a String. Got ${answerData['correctAnswer']}');
        }

        final questionType = data['type'];
        // Validate that the question type is a type that exists
        if (questionType != 'textQuestion' && questionType != 'imageQuestion') {
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
        final question = Question.fromJson(data);
        questions.add(question);
      } on FormatException catch (e) {
        print('Format Exception! Skipping this question.');
        continue;
      } catch (e) {
        print('An unknown exception occurred!');
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

// Player fromJson(Map<String, dynamic> json) {
//   if (json.containsKey('id') &&
//       json['id'] is String &&
//       json.containsKey('name') &&
//       json['id'] is String &&
//       json.containsKey('score') &&
//       json['id'] is int &&
//       json.containsKey('leaderboardStats')) {
//     final leaderboardJson = json['leaderboardStats'] as Map<String, dynamic>;
//     if (leaderboardJson.containsKey('highestScore') &&
//         json['highestScore'] is int &&
//         leaderboardJson.containsKey('cumulativeScore') &&
//         json['cumulativeScore'] is int &&
//         leaderboardJson.containsKey('date') &&
//         json['date'] is Timestamp) {
//       return Player(
//         id: json['id'] as String,
//         name: json['name'] as String,
//         currentScore: json['score'] as int,
//         leaderboardStats: LeaderboardStats(
//           highestScore: json['leaderboardStats']['highestScore'] as int,
//           date: (json['leaderboardStats']['date'] as Timestamp).toDate(),
//           cumulativeScore: json['leaderboardStats']['cumulativeScore'] as int,
//         ),
//       );
//     }
//   } else {
//     throw FormatException('');
//   }
// }
